//
//  EnvironmentManager.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 14/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine
import AuthenticationServices
import CryptoKit

class EnvironmentManager: NSObject, ObservableObject {
    
    
    // MARK: - Database variables
    
    private var database = DatabaseManager()
    
    // MARK: - Combine variables
    
    var didchange = PassthroughSubject<EnvironmentManager, Never>()
    
    // User profile updated throughout classes
    @Published var profile: AuthenticationProfile? {
        didSet {
            self.didchange.send(self)
        }
    }
    
    // Listener that changes user profile status variable
    var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Apple Login variables
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    @Environment(\.window) var window: UIWindow?
    
    // MARK: - Encrypting functions
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // MARK: - Authentication functions
    
    /// Listen authentication status of a profile. When it is logged in, user profile is fetched.
    func listen() {
        
        handle = Auth.auth().addStateDidChangeListener { (_, user) in
            
            if let user = user {
                
                self.database.getUserProfile(userUid: self.replaceEmail(email: user.email ?? ""), completion: { profile in
                    
                    self.profile = profile
                    
                    #warning("This is just for DEBUG purposes")
                    if profile != nil {
                        print(profile.email ?? "COD01: erro de email")
                        print(profile.id)
                        print(profile.name)
                    } else {
                        print(profile)
                    }
                })
            } else {
                
                self.profile = nil
            }
        }
    }
    
    /// Sign up a user with email and password.
    /// - Parameters:
    ///   - email: email used to sign up
    ///   - password: password used to sign up
    ///   - name: users full name
    ///   - handler: callback used to save user profile into the database
    func signUp(email: String, password: String, name: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let userResult = user?.user {
                
                self.database.saveNewProfile(email: self.replaceEmail(email: email), name: name, userUid: userResult.uid)
            } else {
                
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    /// Sign in a user with email and password.
    /// - Parameters:
    ///   - email: email used to sign in
    ///   - password: password used to sign in
    ///   - handler: callback used to sign in user
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    /// Logout a user.
    func logout() {
        
        do {
            try Auth.auth().signOut()
            self.profile = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func unbind() {
        if let handle = handle {
            
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func replaceEmail(email: String) -> String {
        
        if email.contains(".") {
            return email.replacingOccurrences(of: ".", with: "(dot)").lowercased()
        } else {
            return email.replacingOccurrences(of: "(dot)", with: ".").lowercased()
        }
    }
    
    deinit {
        unbind()
    }
}

@available(iOS 13.0, *)
extension EnvironmentManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error!.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension EnvironmentManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
}

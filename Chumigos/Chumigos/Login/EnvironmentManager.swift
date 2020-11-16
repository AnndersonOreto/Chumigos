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
    
    @Published var signInError: Bool = false
    @Published var signUpError: String = ""
    
    // MARK: - Apple Login variables
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    @Environment(\.window) var window: UIWindow?
    
    // MARK: - Encrypting functions
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
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
            
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    print("Error: \(error.localizedDescription)")
                // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                case .emailAlreadyInUse:
                    print("Error: \(error.localizedDescription)")
                    self.signUpError = "Email já está em uso."
                // Error: The email address is already in use by another account.
                case .invalidEmail:
                    print("Error: \(error.localizedDescription)")
                    self.signUpError = "Verifique se o seu email está escrito corretamente."
                // Error: The email address is badly formatted.
                case .weakPassword:
                    print("Error: \(error.localizedDescription)")
                    self.signUpError = "Senha muito fraca."
                // Error: The password must be 6 characters long or more.
                default:
                    print("Error: \(error.localizedDescription)")
                    self.signUpError = error.localizedDescription
                }
            } else {
                
                if let userResult = user?.user {
                    
                    self.database.saveNewProfile(email: self.replaceEmail(email: email), name: name, userUid: userResult.uid, lives: 5)
                } else {
                    
                    print(error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    /// Sign in a user with email and password.
    /// - Parameters:
    ///   - email: email used to sign in
    ///   - password: password used to sign in
    ///   - handler: callback used to sign in user
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error as NSError? {
                
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    self.signInError = true
                // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                case .userDisabled:
                    self.signInError = true
                // Error: The user account has been disabled by an administrator.
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    self.signInError = true
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    self.signInError = true
                default:
                    print("Error: \(error.localizedDescription)")
                    self.signInError = true
                }
            } else {
                self.signInError = false
            }
        }
    }
    
    /// Resets user password.
    /// - Parameters:
    ///   - email: user email to send email
    ///   - handler: callback for error
    func resetPassword(email: String, handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound:
                    print("Error message: \(error.localizedDescription)")
                // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                case .invalidEmail:
                    print("Error message: \(error.localizedDescription)")
                // Error: The email address is badly formatted.
                case .invalidRecipientEmail:
                    print("Error message: \(error.localizedDescription)")
                // Error: Indicates an invalid recipient email was sent in the request.
                case .invalidSender:
                    print("Error message: \(error.localizedDescription)")
                // Error: Indicates an invalid sender email is set in the console for this action.
                case .invalidMessagePayload:
                    print("Error message: \(error.localizedDescription)")
                // Error: Indicates an invalid email template for sending update email.
                default:
                    print("Error message: \(error.localizedDescription)")
                }
            } else {
                print("Reset password email has been successfully sent")
            }
        }
    }
    
    func reauthenticate(password: String) {
        
        guard let email = profile?.email else { return }
        
        let user = Auth.auth().currentUser
        var credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        // Prompt the user to re-provide their sign-in credentials
        
        user?.reauthenticate(with: credential) { (result, err) in
            if let err = err {
                // An error happened.
                print(err.localizedDescription)
            } else {
                // User re-authenticated.
            }
        }
    }
    
    func changePassword(newPassword: String) {
        
        Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
          // ...
        }
    }
    
    func deleteAccount() {
        
        Auth.auth().currentUser?.delete(completion: { (error) in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    print("Email/ Password sign in provider is new disabled")
                case .requiresRecentLogin:
                    // Error: Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.
                    print("Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.")
                default:
                    print("Error message: \(error.localizedDescription)")
                }
            } else {
                print("User account is deleted successfully")
            }
        })
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
                if let error = error as NSError? {
                    
                    switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                        print("Error: \(error.localizedDescription)")
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    case .userDisabled:
                        print("Error: \(error.localizedDescription)")
                    // Error: The user account has been disabled by an administrator.
                    case .wrongPassword:
                        // Error: The password is invalid or the user does not have a password.
                        self.signInError = true
                    case .invalidEmail:
                        // Error: Indicates the email address is malformed.
                        self.signInError = true
                    default:
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    self.signInError = false
                }
                
                let replacedEmail = self.replaceEmail(email: authResult?.user.email ?? "")
                //Get user profile
                self.database.getUserProfile(userUid: replacedEmail, completion: { profile in
                    self.profile = profile
                    if profile.name.isEmpty {
                        let name = (appleIDCredential.fullName?.givenName ?? "") + " " +
                            (appleIDCredential.fullName?.familyName ?? "")
                        self.database.saveNewProfile(email: replacedEmail,
                                                     name: name,
                                                     userUid: authResult?.user.email ?? "", lives: 5)
                    }
                })
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

extension String {
    func replaceEmail() -> String {
        if self.contains(".") {
            return self.replacingOccurrences(of: ".", with: "(dot)").lowercased()
        } else {
            return self.replacingOccurrences(of: "(dot)", with: ".").lowercased()
        }
    }
}

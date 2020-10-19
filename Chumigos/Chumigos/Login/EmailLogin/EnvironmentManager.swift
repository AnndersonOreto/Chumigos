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

class EnvironmentManager: ObservableObject {
    
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
    
    @Published var isUserAuthenticated: AuthState = .undefined
    let userIdentifierKey = "userIdentifier"
    
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
    
    func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        guard let userIdentifier = UserDefaults.standard.string(forKey: userIdentifierKey) else {
            print("User identifier does not exist")
            self.isUserAuthenticated = .undefined
            completion(.undefined)
            return
        }
        if userIdentifier == "" {
            print("User identifier is empty string")
            self.isUserAuthenticated = .undefined
            completion(.undefined)
            return
        }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid. Show Home UI Here
                    print("Credential state: .authorized")
                    self.isUserAuthenticated = .signedIn
                    completion(.signedIn)
                    break
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    print("Credential state: .revoked")
                    self.isUserAuthenticated = .undefined
                    completion(.undefined)
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
                    print("Credential state: .notFound")
                    self.isUserAuthenticated = .signedOut
                    completion(.signedOut)
                    break
                default:
                    break
                }
            }
        }
    }
}

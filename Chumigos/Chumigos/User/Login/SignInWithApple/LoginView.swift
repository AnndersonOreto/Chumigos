//
//  LoginView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager
    
    @State private var signInWithAppleDelegates: SignInWithAppleDelegates! = nil
    
    @Environment(\.window) var window: UIWindow?
    
    var body: some View {
        VStack {
        Text("Hello, World!")
        }.onAppear {
            switch signInWithAppleManager.isUserAuthenticated {
            
            case .undefined:
                self.performExistingAccountFlows()
            case .signedOut:
                print("signedOut")
            case .signedIn:
                print("signedIn")
            }
        }
    }
    
    private func performExistingAccountFlows() {
        
        #if targetEnvironment(simulator)
        let requests = [
            ASAuthorizationAppleIDProvider().createRequest(),
            ASAuthorizationPasswordProvider().createRequest()
        ]
        
        performSignIn(using: requests)
        #endif
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        
        signInWithAppleDelegates = SignInWithAppleDelegates(window: window, onSignedIn: { (result) in
            switch result {
            
            case .success(let userId):
                UserDefaults.standard.set(userId, forKey: self.signInWithAppleManager.userIdentifierKey)
                self.signInWithAppleManager.isUserAuthenticated = .signedIn
            case .failure(_):
                print("could not perform sign in")
                self.signInWithAppleManager.isUserAuthenticated = .signedOut
            }
        })
        
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = signInWithAppleDelegates
        controller.presentationContextProvider = signInWithAppleDelegates
        
        controller.performRequests()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

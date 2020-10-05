//
//  LoginLoginView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct LoginLoginView: View {
    
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager
    
    @State private var signInWithAppleDelegates: SignInWithAppleDelegates! = nil
    
    @Environment(\.window) var window: UIWindow?
    
    var body: some View {
        SignInWithAppleButton().frame(width: 200, height: 60).padding()
            .onTapGesture {
                self.showAppleLogin()
            }
    }
    
    private func showAppleLogin() {
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        performSignIn(using: [request])
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        
        signInWithAppleDelegates = SignInWithAppleDelegates(window: window, onSignedIn: { (result) in
            switch result {
            
            case .success(let userId):
                UserDefaults.standard.set(userId, forKey: self.signInWithAppleManager.userIdentifierKey)
                self.signInWithAppleManager.isUserAuthenticated = .signedIn
            case .failure(_):
                print("teste1")
            }
        })
        
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = signInWithAppleDelegates
        controller.presentationContextProvider = signInWithAppleDelegates
        
        controller.performRequests()
    }
}

struct LoginLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginLoginView()
    }
}

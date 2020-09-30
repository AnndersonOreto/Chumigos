//
//  AppleSignInCoordinator.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 30/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import AuthenticationServices

// Used in login view model
class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate {
    // Backend Service Variable
    var loginService: LoginService
    var loginViewModel: SignInWithAppleViewModel
    
    init(loginService: SignInWithAppleViewModel = LoginAPI(), loginVM: SignInWithAppleViewModel) {
        self.loginViewModel = loginVM
        self.loginService = loginService
    }
    
    // Shows Sign in with Apple UI
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // Delegate methods
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Get user details
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email ?? ""
            let name = (fullName?.givenName ?? "") + (" ") + (fullName?.familyName ?? "")
            
            // Save user details or fetch them
            // Sign in with Apple only gives full name and email once
            // Below is a sample code of how it can be done
            KeychainManager.saveOrRetrieve(name, email)
            
            // Example: Make network request to backend
            // OR, perform any other operation as per your app's use case
            loginService.callAppleAuthCallback()
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

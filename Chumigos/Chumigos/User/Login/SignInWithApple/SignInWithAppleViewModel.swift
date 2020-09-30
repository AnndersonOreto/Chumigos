//
//  File.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 30/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

import Combine

class SignInWithAppleViewModel: ObservableObject {
    
    private lazy var appleSignInCoordinator = AppleSignInCoordinator(loginVM: self)
    
    func attemptAppleSignIn() {
        appleSignInCoordinator.handleAuthorizationAppleIDButtonPress()
    }
    
}

//
//  SignInWithAppleButton.swift
//  SwiftUISignInWithApple
//
//  Created by Alex Nagy on 03/11/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<SignInWithAppleButton>) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .continue, style: .black)
    }
    
    func updateUIView(_ uiView: SignInWithAppleButton.UIViewType, context: UIViewRepresentableContext<SignInWithAppleButton>) {
    }
}

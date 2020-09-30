//
//  SignInWithApple.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 30/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI
import AuthenticationServices

final class SignInWithApple: UIViewRepresentable {

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context:
        Context) {
    }
}

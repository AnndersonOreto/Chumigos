//
//  TestSignInWithAppleView.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 30/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct TestSignInWithAppleView: View {
    
    @ObservedObject var viewModel = SignInWithAppleViewModel()

    
    var body: some View {
        VStack {
            SignInWithApple()
                .frame(width: 280, height: 60)
                .onTapGesture {
                    self.viewModel.attemptAppleSignIn()
            }

        }
    }
    
}

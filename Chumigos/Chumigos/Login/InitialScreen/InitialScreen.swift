//
//  IniticalLoginScreenView.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

enum InitialFlow {
    case LOGIN, REGISTER, INITIAL
}

struct InitialScreen: View {
    
    @State var currentScreen: InitialFlow = .INITIAL
    
    var body: some View {
        HStack(spacing: 0) {
            TestColorCarousel()
                .overlay(
                    Image("login-screen-art")
                        .resizable()
                        .scaledToFit()
                )
            
            switchViews()
        
        }.edgesIgnoringSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    func switchViews() -> AnyView {
        switch currentScreen {
        case .LOGIN:
            return AnyView(SignInView(currentScreen: $currentScreen))
        case .REGISTER:
            return AnyView(SignUpView(currentScreen: $currentScreen))
        case .INITIAL:
            return AnyView(WelcomeView(currentScreen: $currentScreen))
        }
    }
}

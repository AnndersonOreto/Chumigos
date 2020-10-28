//
//  InicialScreen.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 08/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    @Binding var currentScreen: InitialFlow
    
    @EnvironmentObject var environmentManager: EnvironmentManager

    
    var body: some View {
        ZStack {
            Color.Ghost
            VStack {
                VStack(spacing: screenWidth * 0.088) {
                    CustomText("Bem-vindo ao Loggio!")
                        .dynamicFont(size: 30, weight: .bold)
                        .foregroundColor(Color.Eel)
                    
                    CustomText("Faça o login ou inscreva-se:")
                        .dynamicFont(size: 18, weight: .regular)
                        .foregroundColor(Color.Eel)
                }.padding(.top, screenWidth * 0.1097152429)
                
                VStack(spacing: screenWidth * 0.005) {
                    Button(action : {
                        self.currentScreen = InitialFlow.REGISTER
                    }) {
                        Text("Cadastrar").dynamicFont(size: 20, weight: .bold)
                    }.buttonStyle(AppButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Whale,
                                                 buttonBackgroundColor: .Narwhal, isButtonEnable: true,
                                                 textColor: .white, width: screenWidth * 0.243))
                    
                    Button(action: {
                        self.currentScreen = InitialFlow.LOGIN
                    }) {
                        Text("Entrar").dynamicFont(size: 20, weight: .bold)
                    }.buttonStyle(AppButtonStyle(buttonColor: .Owl, pressedButtonColor: .Turtle,
                                                 buttonBackgroundColor: .TreeFrog, isButtonEnable: true,
                                                 textColor: .white, width: screenWidth * 0.243))
                    
                    CustomText("Entrar sem cadastro")
                        .dynamicFont(size: 16, weight: .regular)
                        .foregroundColor(Color.Humpback)
                        .onTapGesture {
                            //TODO: Login anonimo
                    }.padding(.top, screenWidth * 0.02)
                }.padding(.top, screenWidth * 0.04690117253)
                
                Spacer()
                
                SignInWithAppleButton().onTapGesture {
                    self.environmentManager.startSignInWithAppleFlow()
                }.frame(width: screenWidth * 0.243718593, height: screenWidth * 0.04)
                .padding(.bottom, screenWidth * 0.1097152429)
                
            }.frame(width: screenWidth / 2)
        }
    }
}

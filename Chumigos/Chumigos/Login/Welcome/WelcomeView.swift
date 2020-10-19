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
    
    var body: some View {
        VStack {            
            VStack(spacing: screenWidth * 0.088) {
                CustomText("Bem-vindo ao Loggio!")
                    .dynamicFont(size: 30, weight: .bold)
                    .foregroundColor(Color.textColor)
                
                CustomText("Faça o login ou inscreva-se:")
                    .dynamicFont(size: 18, weight: .regular)
                    .foregroundColor(Color.textColor)
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
            }.padding(.top, screenWidth * 0.04690117253)
            
            Spacer()
            
            Button(action: {
                //Without login
            }) {
                Text("Entrar sem cadastro").dynamicFont(size: 20, weight: .bold)
            }.padding(.bottom, screenWidth * 0.07118927973)
                .buttonStyle(AppButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Whale,
                                            buttonBackgroundColor: .Narwhal, isButtonEnable: true,
                                            textColor: .white, width: screenWidth * 0.243))
            
        }.frame(width: screenWidth / 2)
    }
}

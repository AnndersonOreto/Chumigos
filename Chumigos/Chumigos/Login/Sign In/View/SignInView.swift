//
//  LoginView.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    
    @Binding var currentScreen: InitialFlow
    
    @State var emailTextField: String = ""
    @State var passwordTextField: String = ""
    @State var error: String = ""
    
    @EnvironmentObject var environmentManager: EnvironmentManager

    
    var body: some View {
        VStack {
            
            Button(action: {
                self.currentScreen = InitialFlow.INITIAL
            }) {
                Image(systemName: "xmark")
                    .dynamicFont(name: "Rubik", size: 34, weight: .bold)
                    .foregroundColor(.xMark)
            }.buttonStyle(PlainButtonStyle())
                .padding(.top, screenWidth * 0.023)
                .padding(.leading, -(screenWidth * 0.23))
            
            Spacer()
            
            VStack {
                CustomText("Entrar")
                    .dynamicFont(size: 30, weight: .bold)
                    .foregroundColor(Color.textColor)
                    .padding(.bottom, screenWidth * 0.05)
                
                VStack(spacing: screenWidth * 0.01423785595) {
                    CustomTextField(placeholder: "E-mail", text: $emailTextField)
                    CustomTextField(placeholder: "Senha", text: $passwordTextField)
                }.frame(width: screenWidth * 0.3433835846)
                
                //TODO: Funcao de Sign In
                Button(action: {
                    //Sign In
                    self.environmentManager.signIn(email: self.emailTextField,
                                                   password: self.passwordTextField) { (result, error) in
                        
                        if let error = error {
                            
                            self.error = error.localizedDescription
                        } else {
                            
                            self.emailTextField = ""
                            self.passwordTextField = ""
                        }
                    }
                }) {
                    Text("Entrar").dynamicFont(size: 20, weight: .bold)
                }.padding(.vertical, screenWidth * 0.03266331658)
                    .buttonStyle(AppButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Whale,
                                                buttonBackgroundColor: .Narwhal, isButtonEnable: true,
                                                textColor: .white, width: screenWidth * 0.243))
                
                Button(action: {
                    //Forgot password
                }) {
                    CustomText("Esqueceu a senha?")
                        .dynamicFont(size: 18, weight: .regular)
                        .foregroundColor(Color.xMark)
                    
                }
            }.frame(width: screenWidth/2)
            Spacer()
        }.background(Color.background)
    }
}

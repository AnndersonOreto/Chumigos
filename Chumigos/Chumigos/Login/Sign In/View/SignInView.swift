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
    
    @State var keyboardOffSet: CGFloat = CGFloat.zero
    
    @EnvironmentObject var environmentManager: EnvironmentManager

    var body: some View {
        
        ZStack {
            
            //i separated this button so it doesn't go up anymore with the view
            VStack {
                Button(action: {
                    self.currentScreen = InitialFlow.INITIAL
                }) {
                    Image(systemName: "xmark")
                        .dynamicFont(name: "Rubik", size: 34, weight: .bold)
                        .foregroundColor(.Humpback)
                }.buttonStyle(PlainButtonStyle())
                    .padding(.top, screenWidth * 0.023)
                    .padding(.leading, -(screenWidth * 0.23))
                
                Spacer()
            }
            
            VStack {
                VStack {
                    CustomText("Entrar")
                        .dynamicFont(size: 30, weight: .bold)
                        .foregroundColor(Color.Eel)
                        .padding(.bottom, self.keyboardOffSet != CGFloat.zero ? screenWidth * 0.03266331658 : screenWidth * 0.05)
                        .padding(.top, self.keyboardOffSet != CGFloat.zero ? screenWidth * 0.0462 : 0)
                    
                    VStack(spacing: screenWidth * 0.01423785595) {
                        CustomTextField(placeholder: "E-mail", text: $emailTextField)
                        .overlay(self.environmentManager.signInError ? RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3) : nil)
                        CustomPasswordField(placeholder: "Senha", text: $passwordTextField)
                        .overlay(self.environmentManager.signInError ? RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3) : nil)
                    }.frame(width: screenWidth * 0.3433835846)

                    CustomText(self.environmentManager.signInError ? "Email ou senha invalidos." : "")
                    .dynamicFont(size: 18, weight: .regular)
                    .foregroundColor(Color.red)
                    
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
                    }
                    .padding(.top, self.keyboardOffSet != CGFloat.zero ? screenWidth * 0.02 : screenWidth * 0.03266331658)
                    .padding(.bottom, self.keyboardOffSet != CGFloat.zero ? 10 : screenWidth * 0.03266331658)
                        .buttonStyle(AppButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Whale,
                                                    buttonBackgroundColor: .Narwhal, isButtonEnable: true,
                                                    textColor: .white, width: screenWidth * 0.243))
                    
                    Button(action: {
                        //Forgot password
                    }) {
                        CustomText("Esqueceu a senha?")
                            .dynamicFont(size: 18, weight: .regular)
                            .foregroundColor(Color.Humpback)
                        
                    }
                }.frame(width: screenWidth/2)
                .offset(y: -self.keyboardOffSet)
                .animation(.spring())
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                        
                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                        let height = value?.height
                        
                        self.keyboardOffSet = (height ?? 0)/2
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                        
                        self.keyboardOffSet = 0
                    }
                }
            }
        }
        .background(Color.Ghost)
    }
}

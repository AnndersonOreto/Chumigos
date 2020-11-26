//
//  SignUpView.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    @Binding var currentScreen: InitialFlow
    
    @State var emailTextField: String = ""
    @State var fullNameTextField: String = ""
    @State private var error: String = ""
    @State var passwordTextField: String = ""
    @State var showTOS: Bool = false
    
    @State var keyboardOffSet: CGFloat = CGFloat.zero
    
    var body: some View {
        
        ZStack {
            Color.Ghost
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
                
                Spacer()
                
                VStack {
                    CustomText("Inscrever-se")
                        .dynamicFont(size: 30, weight: .bold)
                        .foregroundColor(Color.Eel)
                        .padding(.bottom, self.keyboardOffSet != CGFloat.zero ? 0 : screenWidth * 0.05)
                        .padding(.top, self.keyboardOffSet != CGFloat.zero ? screenWidth * 0.0462 : 0)
                    
                    VStack(spacing: screenWidth * 0.01423785595) {
                        CustomTextField(placeholder: "E-mail", text: $emailTextField)
                        .overlay(!self.environmentManager.signUpError.isEmpty ?
                                RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3) : nil)
                        CustomTextField(placeholder: "Nome Completo", text: $fullNameTextField)
                        .overlay(!self.environmentManager.signUpError.isEmpty ?
                                RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3) : nil)
                        CustomPasswordField(placeholder: "Senha", text: $passwordTextField)
                        .overlay(!self.environmentManager.signUpError.isEmpty ?
                                RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3) : nil)

                    }.frame(width: screenWidth * 0.3433835846)

                    CustomText(!self.environmentManager.signUpError.isEmpty ?
                           self.environmentManager.signUpError : "")
                    .dynamicFont(size: 16, weight: .regular)
                    .foregroundColor(Color.red)
                    
                    HStack(spacing: 0) {
                        CheckView(isChecked: true, title: "Li e aceito os ")
                        CustomText("Termos de Serviço")
                            .dynamicFont(size: 16, weight: .regular)
                            .foregroundColor(Color.Humpback)
                            .onTapGesture {
                                //Abrir modal
                                self.showTOS = true
                        }
                    }.padding(.top, screenWidth * 0.0175879397)
                    
                    Button(action: {
                        UIApplication.shared.endEditing()
                        //Sign up
                        self.environmentManager.signUp(email: self.emailTextField,
                                                       password: self.passwordTextField,
                                                       name: self.fullNameTextField) { (result, error) in
                            
                            if let error = error {
                                
                                self.error = error.localizedDescription
                            } else {
                                
                                self.fullNameTextField = ""
                                self.passwordTextField = ""
                                self.emailTextField = ""
                            }
                        }
                    }) {
                        Text("Cadastrar").dynamicFont(size: 20, weight: .bold)
                    }.padding(.top, self.keyboardOffSet != CGFloat.zero ? 0 : screenWidth * 0.045)
                        .padding(.bottom, screenWidth * 0.02)
                        .buttonStyle(AppButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Whale,
                                                    buttonBackgroundColor: .Narwhal, isButtonEnable: true,
                                                    textColor: .white, width: screenWidth * 0.243))
                }.frame(width: screenWidth/2)
                    .sheet(isPresented: $showTOS) {
                        ScrollView {
                            CustomText(TermsOfServices.textTOS).padding(50)
                        }
                }
                Spacer()
            }
            .offset(y: -self.keyboardOffSet)
            .animation(.spring())
            .onAppear {
                NotificationCenter.default.addObserver(forName:
                UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    let height = value?.height
                    
                    self.keyboardOffSet = (height ?? 0)/2
                }
                
                NotificationCenter.default.addObserver(forName:
                UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    
                    self.keyboardOffSet = CGFloat.zero
                }
            }
        }
    }
}

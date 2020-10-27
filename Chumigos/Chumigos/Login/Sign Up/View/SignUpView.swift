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
    
    let textTOS: String = """

                                    TERMOS DE SERVICO LOGGIO

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam fringilla, velit a auctor bibendum, ipsum nisi feugiat nulla, ullamcorper luctus nulla neque laoreet est. Quisque lacus erat, sagittis sed facilisis id, interdum id elit. Sed ac fermentum mauris. Proin enim tellus, semper et nulla id, consectetur pretium lorem. Vivamus lorem sapien, congue quis massa eget, molestie gravida est. Praesent accumsan metus ut tellus suscipit, sed tristique libero dignissim. Nullam dapibus rhoncus mi, quis malesuada urna auctor nec. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed quis tempor neque.
    
    Mauris a facilisis odio. Duis bibendum est nulla, et maximus massa hendrerit at. Nam blandit eleifend consequat. Maecenas ut tellus et sem consectetur sollicitudin. Donec laoreet, velit in cursus sollicitudin, odio urna volutpat nibh, ac luctus lacus lacus vitae erat. Sed finibus, diam non ornare scelerisque, elit tortor luctus libero, vitae aliquam nunc nulla ut elit. Curabitur eget orci non est maximus hendrerit id sed ligula.
    
    Sed quis scelerisque metus, nec malesuada nunc. Sed ultricies placerat fringilla. Fusce diam orci, congue lobortis imperdiet feugiat, sodales facilisis sapien. Integer venenatis eros id diam ultricies mollis. Vivamus in semper nibh. Sed non sagittis erat. Mauris interdum velit sit amet lacus pretium venenatis. Praesent ac ligula tortor. Ut gravida nisi id odio eleifend, ac consectetur dui placerat. Duis tellus quam, commodo a vulputate a, efficitur ac ligula.
    
    Sed pulvinar pellentesque consequat. Mauris lobortis euismod nisi ut tempor. Aenean neque ligula, dictum sed velit ut, ullamcorper auctor diam. Phasellus id odio sem. Maecenas vel pharetra tellus. Phasellus volutpat volutpat nulla, nec tempor ipsum efficitur at. Interdum et malesuada fames ac ante ipsum primis in faucibus. Fusce nec auctor ante. Phasellus tristique id turpis et hendrerit. Suspendisse quis odio cursus, eleifend orci vel, vestibulum justo.
    
    Proin magna nunc, porttitor suscipit metus iaculis, porta sollicitudin metus. Interdum et malesuada fames ac ante ipsum primis in faucibus. In dolor nisl, egestas ut mollis eu, bibendum ut dui. Vivamus eget nulla magna. Cras congue consequat tellus sed imperdiet. Suspendisse aliquet non nibh vitae blandit. Nulla sit amet elit sit amet sapien finibus sollicitudin id et libero. Curabitur non quam quis turpis finibus egestas. In id nisi hendrerit, fermentum massa a, ornare arcu. Mauris quis dapibus felis, et finibus lorem. Curabitur sit amet tellus vitae lectus vulputate semper. Donec arcu enim, porttitor a lectus ut, pharetra convallis est.
    """
    
    var body: some View {
        
        ZStack {
            //i separated this button so it doesn't go up anymore with the view
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
            }
            
            VStack {
                
                Spacer()
                
                VStack {
                    CustomText("Inscrever-se")
                        .dynamicFont(size: 30, weight: .bold)
                        .foregroundColor(Color.textColor)
                        .padding(.bottom, self.keyboardOffSet != CGFloat.zero ? 0 : screenWidth * 0.05)
                        .padding(.top, self.keyboardOffSet != CGFloat.zero ? screenWidth * 0.0462 : 0)
                    
                    VStack(spacing: screenWidth * 0.01423785595) {
                        CustomTextField(placeholder: "E-mail", text: $emailTextField)
                        CustomTextField(placeholder: "Nome Completo", text: $fullNameTextField)
                        CustomTextField(placeholder: "Senha", text: $passwordTextField)
                    }.frame(width: screenWidth * 0.3433835846)
                    
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
                    
                    //TODO: Funcao para cadastro
                    Button(action: {
                        //Sign up
                        self.environmentManager.signUp(email: self.emailTextField, password: self.passwordTextField, name: self.fullNameTextField) { (result, error) in
                            
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
                            CustomText(self.textTOS).padding(50)
                        }
                }
                Spacer()
            }
            .offset(y: -self.keyboardOffSet)
            .animation(.spring())
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    let height = value?.height
                    
                    self.keyboardOffSet = (height ?? 0)/2
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    
                    self.keyboardOffSet = CGFloat.zero
                }
            }
        }
    }
}

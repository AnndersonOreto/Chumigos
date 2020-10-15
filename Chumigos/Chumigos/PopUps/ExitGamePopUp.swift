//
//  ExitGamePopUp.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 02/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ExitGamePopUp: View {
    
    @Binding var showPopUp: Bool
    var dismissGame: (() -> Void)
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        ZStack {
            Rectangle().fill(Color.background).opacity(0.1)
                .onTapGesture {
                    self.showPopUp = false
                }
            popUpView()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.popUpBackground)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:7, x:0, y:4)
            )
        }
    }
}

//struct ExitGamePopUp_Previews: PreviewProvider {
//    static var previews: some View {
//        ExitGamePopUp()
//    }
//}

extension ExitGamePopUp {
    
    private func popUpView() -> some View {
        VStack {
            // TODO: Trocar pela imagem do polvo
            Image("exit-game-art")
                .resizable()
                .frame(width: screenWidth * 0.077, height: screenWidth * 0.12)
                .padding(.top, screenWidth * 0.027)
                .padding(.bottom, screenWidth * 0.01)
            
            Text("Tem certeza que deseja sair?")
                .dynamicFont(name: "Rubik", size: 20, weight: .regular)
                .foregroundColor(.textColor)
                .padding(.bottom, screenWidth * 0.013)
            
            HStack(spacing: screenWidth * 0.036) {
                Button(action: {
                    self.dismissGame()
                }) {
                    Text("Sair")
                        .dynamicFont(name: "Rubik", size: 20, weight: .bold)
                }.buttonStyle(GameButtonStyle(buttonColor: .Cardinal,
                                              pressedButtonColor: .Cardinal,
                                              buttonBackgroundColor: .FireAnt, isButtonEnable: true,
                                              textColor: .Ghost))
                
                Button(action: {
                    self.showPopUp = false
                }) {
                    Text("Continuar")
                        .dynamicFont(name: "Rubik", size: 20, weight: .bold)
                }.buttonStyle(GameButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Humpback,
                                              buttonBackgroundColor: .Narwhal,
                                              isButtonEnable: true, textColor: .Ghost))
            }.padding(.bottom, screenWidth * 0.032)
                .padding(.horizontal, screenWidth * 0.044)
        }
    }
}

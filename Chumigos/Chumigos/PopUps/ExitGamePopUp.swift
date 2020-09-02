//
//  ExitGamePopUp.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 02/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ExitGamePopUp: View {
    
    var body: some View {
        PopUpView()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.Ghost)
        )
    }
}

struct ExitGamePopUp_Previews: PreviewProvider {
    static var previews: some View {
        ExitGamePopUp()
    }
}

struct PopUpView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            // TODO: Trocar pela imagem do polvo
            Image("icon-abstraction")
                .resizable()
                .frame(width: screenWidth * 0.077, height: screenWidth * 0.12)
                .padding(.top, screenWidth * 0.027)
                .padding(.bottom, screenWidth * 0.01)
            
            Text("Tem certeza que deseja sair?")
                .font(.custom("Rubik", size: 20))
                .foregroundColor(.Eel)
                .padding(.bottom, screenWidth * 0.013)
            
            HStack(spacing: screenWidth * 0.036) {
                Button(action: {
                    //
                }) {
                    Text("Sair")
                        .font(.custom("Rubik", size: 20)).bold()
                }.buttonStyle(GameButtonStyle(buttonColor: .Cardinal, pressedButtonColor: .Cardinal, buttonBackgroundColor: .FireAnt, isButtonEnable: true, textColor: .Ghost))
                
                Button(action: {
                    //
                }) {
                    Text("Continuar")
                        .font(.custom("Rubik", size: 20)).bold()
                }.buttonStyle(GameButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Humpback, buttonBackgroundColor: .Narwhal, isButtonEnable: true, textColor: .Ghost))
            }.padding(.bottom, screenWidth * 0.032)
                .padding(.horizontal, screenWidth * 0.044)
        }
    }
}

//
//  EndGameView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 25/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct EndGameView: View {
    
    // MARK: - View Model
    
    @ObservedObject var progressViewModel: ProgressBarViewModel = ProgressBarViewModel(questionAmount: 5)
    var dismissGame: (() -> Void)
    var restartGame: (() -> Void)
    
    // MARK: - Drawing Contants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    // MARK: - View

    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                // Progress Bar
                ProgressBarView(viewModel: progressViewModel)
                    .padding(.top, screenWidth * 0.015)
                
                Spacer()
                
                Group {
                    Image("fruit-1")
                        .resizable().frame(width: screenWidth * 0.245, height: screenWidth * 0.245, alignment: .center)
                                        
                    // Label
                    Text("Parabéns! Você terminou a tarefa!")
                        .foregroundColor(Color.Eel)
                        .dynamicFont(name: fontName, size: 28, weight: .bold)
                        .padding(.top, screenWidth * 0.03)
                    
                }
                // Arte
                    
                Spacer()
                // Simbolo da trilha
                                
                TrailTile(game: GameObject(gameType: .pattern, gameName: ""))

                Spacer()
                
                // Inicio
                Button(action: {
                    self.dismissGame()
                    self.restartGame()
                }) {
                    Text("Início")
                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Humpback, pressedButtonColor: Color.Whale, buttonBackgroundColor: Color.Narwhal, isButtonEnable: true))
                
                // Recomecar
                Button(action: {
                    self.restartGame()
                }) {
                    Text("Recomeçar")
                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Bee, pressedButtonColor: Color.Duck, buttonBackgroundColor: Color.Fox, isButtonEnable: true))
                    .padding(.bottom, 30)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

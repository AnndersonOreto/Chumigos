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
    @State var game: GameObject
    let gameScore: Int
    
    // MARK: - Drawing Contants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    // MARK: - View
    
    
    var body: some View {
        
        ZStack {
            
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Progress Bar
                ProgressBarView(viewModel: progressViewModel)
                    .padding(.vertical, screenWidth * 0.015)
                
                Spacer()
                
                // Arte
                Image(Int.random(in: 0...1) == 0 ? "endgame1" : "endgame2")
                    .resizable().frame(width: screenWidth * 0.29, height: screenWidth * 0.30, alignment: .center)
                
                // Label
                HStack {
                    Text("Parabéns! Você terminou a tarefa!")
                        .foregroundColor(Color.textColor)
                        .dynamicFont(name: fontName, size: 28, weight: .bold)
                    
                    Text("+\(self.gameScore)XP")
                        .foregroundColor(Color.Lion)
                        .dynamicFont(name: fontName, size: 24, weight: .medium)
                }
                .padding(.top, screenWidth * 0.03)
                
                Spacer()
                
                // Simbolo da trilha
                
                TrailTile(game: game)
                    .animation(Animation.easeInOut(duration: 2).delay(1))
                    .onAppear{
                        self.game.increaseCurrentProgress(Float(self.gameScore))
                        #warning("O Chumiga não curtiu, mais além a gente muda.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.game.changeIsCompleted()
                        }
                        CoreDataService.shared.saveGameObject(self.game)
                }
                
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

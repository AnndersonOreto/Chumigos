//
//  EndGameView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 25/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct EndGameView: View {
    
    // MARK: - View Model
    @ObservedObject var progressViewModel: ProgressBarViewModel = ProgressBarViewModel(questionAmount: 5)
    var dismissGame: (() -> Void)
    var restartGame: ((GameObject) -> Void)
    @State var game: GameObject
    let gameScore: Int
    @EnvironmentObject var environmentManager: EnvironmentManager
    let database = DatabaseManager()
    
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
                Image("endgame2")
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
                
                TrailTile(game: game, isEndGame: true)
                    .animation(Animation.easeInOut(duration: 2).delay(1))
                    .onAppear {
                        AppAnalytics.shared.logEvent(of: .gameScore, parameters: [
                            "gameObject": self.game.gameName,
                            "score": self.gameScore
                        ])
                        self.game.increaseCurrentProgress(Float(self.gameScore))
                        self.game.changeIsCompleted()
                        //CoreDataService.shared.saveGameObject(self.game)
                        self.environmentManager.profile?.saveGameObject(self.game)
                        self.database.createTrail(self.environmentManager.profile?.trail ?? [], profileRef: Database.database().reference())
                }
                
                Spacer()
                
                // Inicio
                Button(action: {
                    self.dismissGame()
                }) {
                    Text("Início")
                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Humpback,
                                              pressedButtonColor: Color.Whale,
                                              buttonBackgroundColor: Color.Narwhal,
                                              isButtonEnable: true))
                
                // Recomecar
                Button(action: {
                    self.restartGame(self.game)
                }) {
                    Text("Recomeçar")
                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Bee,
                                              pressedButtonColor: Color.Duck,
                                              buttonBackgroundColor: Color.Fox,
                                              isButtonEnable: true))
                    .padding(.bottom, 30)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

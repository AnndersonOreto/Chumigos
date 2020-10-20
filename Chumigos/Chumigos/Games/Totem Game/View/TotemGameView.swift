//
//  TotemGameView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 17/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct TotemGameView: View {
    
    // MARK: - View Models
    
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    @ObservedObject var viewModel: TotemGameViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: - State variables
    
    @State var buttonIsPressed: Bool = false
    @State var showPopUp: Bool = false
    @State var tileSelected: Int = -1 // None tile selected
    @State var isFinished: Bool = false
    @State var isCorrect: Bool = false
    
    // MARK: - Flag Variables
    
    var game: GameObject
    
    // MARK: - Drawing Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    init(gameDifficulty: Difficulty, game: GameObject) {
        AppAnalytics.shared.logEvent(of: .launchGame, parameters: ["gameObject": game.gameName])
        self.viewModel = TotemGameViewModel(difficulty: gameDifficulty, game: game)
        self.game = game
    }
    
    var body: some View {
        
        // Main stack
        ZStack {
            
            // Dark light mode
            Color.background.edgesIgnoringSafeArea(.all)
            
            //Feedback massage
            ZStack {
                VStack {
                    Spacer()
                    if buttonIsPressed {
                        GameFeedbackMessage(feedbackType: self.viewModel.answerIsCorrect() ? .CORRECT : .WRONG)
                            .padding(.bottom, -(screenWidth * 0.035))
                    }
                }
            }
            
            if !isFinished {
                VStack {
                    
                    // Progress Bar
                    ZStack {
                        
                        // Leave game button
                        HStack {
                            Button(action: {
                                self.showPopUp = true
                            }) {
                                Image(systemName: "xmark")
                                    .dynamicFont(name: fontName, size: 34, weight: .bold)
                                    .foregroundColor(.xMark)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.padding(.leading, screenWidth * 0.0385)
                        
                        HStack {
                            ProgressBarView(viewModel: progressViewModel)
                        }
                    }.padding(.top, screenWidth * 0.015)
                    
                    Spacer()
                    
                    // Stack containing totem and alternatives
                    HStack {
                        
                        // Totem
                        VStack(spacing: 0) {
                            
                            ForEach(self.viewModel.totemPieceList) { piece in
                                ZStack {
                                    Image(piece.imageName).resizable()
                                    Image(piece.face)
                                }
                            }
                        }.frame(width: screenWidth * 0.3, height: screenWidth * 0.43)
                        
                        Spacer()
                        
                        // Alternatives text
                        VStack {
                            
                            Spacer()
                            
                            #warning("offset seria a melhor solucao? fica a duvida")
                            CustomText("Selecione como as peças apareceriam caso estivesse as observando de cima:")
                                .dynamicFont(name: fontName, size: 20, weight: .medium)
                                .foregroundColor(.textColor)
                                .multilineTextAlignment(.center)
                                .frame(width: screenWidth * 0.42)
                                .offset(y: -(screenWidth * 0.053))
                            
                            // Alternatives grid
                            Grid<TotemGameTile>(rows: 2, columns: 2,
                                                vSpacing: screenWidth * 0.0175,
                                                hSpacing: screenWidth * 0.0175,
                                                content: { (row, column) in
                                TotemGameTile(size: self.screenWidth,
                                              imageNameList: self.viewModel.totemAlternativeList[(row * 2) + column],
                                              id: (row * 2) + column, selectedTile: self.$tileSelected,
                                              isCorrect: self.$isCorrect,
                                              isButtonPressed: self.$buttonIsPressed,
                                              selectedUpTopTotem: self.$viewModel.selectedUpTopTotem)
                            })
                            
                            Spacer()
                        }
                    }.padding(.horizontal, screenWidth * 0.1)
                    
                    Spacer()
                    
                    // Confirm button
                    ZStack {
                        
                        // Continue Button
                        if buttonIsPressed {
                            Button(action: {
                                self.confirmQuestion()
                            }) {
                                Text("Continuar")
                                    .dynamicFont(name: fontName, size: 20, weight: .bold)
                            }.buttonStyle(
                                self.viewModel.answerIsCorrect()
                                    ?
                                    // Correct answer
                                    GameButtonStyle(buttonColor: Color.Owl, pressedButtonColor: Color.Turtle,
                                                    buttonBackgroundColor: Color.TreeFrog,
                                                    isButtonEnable: tileSelected != -1)
                                    :
                                    // Wrong answer
                                    GameButtonStyle(buttonColor: Color.white, pressedButtonColor: Color.Swan,
                                                    buttonBackgroundColor: Color.Swan,
                                                    isButtonEnable: tileSelected != -1,
                                                    textColor: Color.Humpback)
                            )
                            .padding(.bottom, 10)
                        } else {
                            //Confirm Button
                            Button(action: {
                                self.buttonIsPressed = true
                                self.isCorrect = self.viewModel.answerIsCorrect()
                            }) {
                                Text("Confirmar")
                                    .dynamicFont(name: fontName, size: 20, weight: .bold)
                            }
                            .buttonStyle(GameButtonStyle(buttonColor: Color.Whale,
                                                         pressedButtonColor: Color.Macaw,
                                                         buttonBackgroundColor: Color.Narwhal,
                                                         isButtonEnable: true))
                            .disabled(false)
                            .padding(.bottom, 10)
                            
                        }
                    }
                }.blur(radius: self.showPopUp ? 16 : 0)
                
            } else {
                EndGameView(progressViewModel: self.progressViewModel,
                            dismissGame: self.dismissGame, restartGame: self.restartGame(game:),
                            game: self.game, gameScore: self.viewModel.gameScore.currentScore)
            }
            
            if self.showPopUp {
                ExitGamePopUp(showPopUp: self.$showPopUp, dismissGame: self.dismissGame)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    func dismissGame() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func restartGame(game: GameObject) {
        AppAnalytics.shared.logEvent(of: .launchGame, parameters: ["gameObject": game.gameName])
        self.viewModel.restartGame()
        self.buttonIsPressed = false
        self.showPopUp = false
        self.isFinished = false
        self.isCorrect = false
        self.progressViewModel.restartProgressBar()
        self.viewModel.game = game
    }
    
    func confirmQuestion() {
        let index = self.progressViewModel.currentQuestion
        self.viewModel.ifWrongAddAnswer(with: index)
        
        if self.progressViewModel.isLastQuestion() && self.viewModel.gameState == .NORMAL {
            AppAnalytics.shared.logEvent(of: .gameRecap, parameters: ["recap_amount": viewModel.wrongAnswers.count, "gameObject": viewModel.game.gameName])
            self.viewModel.gameState = .RECAP
        }
        
        self.viewModel.changeGameScore()
        
        withAnimation(.linear(duration: 0.3)) {
            self.progressViewModel.checkAnswer(isCorrect: self.viewModel.answerIsCorrect(), nextIndex: self.viewModel.getRecapIndex())
        }
        
        self.viewModel.resetGame()
        
        self.buttonIsPressed = false
        self.tileSelected = -1
        
        if self.viewModel.gameState == .RECAP && self.viewModel.wrongAnswers.isEmpty {
            self.isFinished = true
            self.progressViewModel.currentQuestion = -1
        }
        
        self.viewModel.removeRecapGame()
    }
}

struct TotemGameTile: View {
    
    // 1366
    var size: CGFloat
    var imageNameList: [String]
    var id: Int
    @Binding var selectedTile: Int
    @Binding var isCorrect: Bool
    @Binding var isButtonPressed: Bool
    @Binding var selectedUpTopTotem: [String]
    
    var body: some View {
        
        ZStack {
            
            ForEach(imageNameList.reversed(), id: \.self) { image in
                Image(image)
                    .resizable()
                    .padding(.horizontal, self.size * 0.0146)
                    .padding(.vertical, self.size * 0.025)
                    .frame(width: self.size * 0.186, height: self.size * 0.142)
            }
            
        }.overlay(
            ZStack {
                if self.selectedTile == self.id {
                    
                    if isButtonPressed && isCorrect {
                        
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.TreeFrog, lineWidth: 9)
                        GeometryReader { geometry in
                            Image("correct-icon")
                                .frame(width: self.size * 0.036, height: self.size * 0.036)
                                .position(x: geometry.size.width-5, y: 5)
                        }
                    } else if isButtonPressed {
                        
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.FireAnt, lineWidth: 9)
                        
                        GeometryReader { geometry in
                            Image("wrong-icon")
                                .frame(width: self.size * 0.036, height: self.size * 0.036)
                                .position(x: geometry.size.width-5, y: 5)
                        }
                    } else {
                        
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.Bee, lineWidth: 9)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.optionBorder, lineWidth: 2)
                }
            }
        )
        .onTapGesture {
            self.selectedTile = self.id
            self.selectedUpTopTotem = self.imageNameList
        }
    }
}

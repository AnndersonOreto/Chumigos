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
    @State var selectedUpTopTotem: [String] = []
    
    // MARK: - Flag Variables
    
    var game: GameObject
    
    // MARK: - Drawing Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    init(gameDifficulty: Difficulty, game: GameObject) {
        self.viewModel = TotemGameViewModel(difficulty: gameDifficulty)
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
                        GameFeedbackMessage(feedbackType: self.checkAnswer() ? .CORRECT : .WRONG)
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
                            
                            ForEach(self.viewModel.totemPieceList, id: \.self) { piece in
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
                            Grid<TotemGameTile>(rows: 2, columns: 2, spacing: screenWidth * 0.0175, content: { (row, column) in
                                TotemGameTile(size: self.screenWidth,
                                              imageNameList: self.viewModel.totemAlternativeList[(row * 2) + column],
                                              id: (row * 2) + column, selectedTile: $tileSelected,
                                              isCorrect: $isCorrect,
                                              isButtonPressed: $buttonIsPressed,
                                              selectedUpTopTotem: $selectedUpTopTotem)
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
                                self.checkAnswer()
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
                                isCorrect = self.checkAnswer()
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
                            dismissGame: self.dismissGame, restartGame: self.restartGame,
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
    
    func restartGame() {
        self.buttonIsPressed = false
        self.showPopUp = false
        self.isFinished = false
        self.isCorrect = false
        self.progressViewModel.restartProgressBar()
        self.viewModel.resetGame()
    }
    
    func confirmQuestion() {
        if self.progressViewModel.isLastQuestion() {
            self.isFinished = true
        }
        
        self.viewModel.changeGameScore(isAnswerCorrect: self.checkAnswer())
        
        withAnimation(.linear(duration: 0.3)) {
            self.progressViewModel.checkAnswer(isCorrect: self.checkAnswer(), nextIndex: self.viewModel.getRecapIndex())
        }
        
        self.viewModel.resetGame()
        
        self.buttonIsPressed = false
        self.tileSelected = -1
        
        if self.isFinished {
            self.progressViewModel.currentQuestion = -1
        }
    }
    
    func checkAnswer() -> Bool {
        
        return self.selectedUpTopTotem == self.viewModel.correctUpTopTotem
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
                    .padding(.horizontal, size * 0.0146)
                    .padding(.vertical, size * 0.025)
                    .frame(width: size * 0.186, height: size * 0.142)
            }
            
        }.overlay(
            ZStack {
                if self.selectedTile == self.id {
                    
                    if isButtonPressed && isCorrect {
                        
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.TreeFrog, lineWidth: 9)
                        GeometryReader { geometry in
                            Image("correct-icon")
                                .frame(width: size * 0.036, height: size * 0.036)
                                .position(x: geometry.size.width-5, y: 5)
                        }
                    } else if isButtonPressed {
                        
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.FireAnt, lineWidth: 9)
                        
                        GeometryReader { geometry in
                            Image("wrong-icon")
                                .frame(width: size * 0.036, height: size * 0.036)
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

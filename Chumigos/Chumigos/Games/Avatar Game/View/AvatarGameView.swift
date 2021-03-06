//
//  AvatarGameView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 04/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct AvatarGameView: View {
    
    // MARK: - View Model
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    @ObservedObject var viewModel: AvatarGameViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var screenWidth = UIScreen.main.bounds.height
    
    // MARK: - State Variables
    @State var isFinished: Bool = false
    @State var showPopUp: Bool = false
    @State var showChatBalloon = true
    
    // MARK: - Face's Variables
    let avatarWidth = UIScreen.main.bounds.height * 0.63
    let avatarHeight = UIScreen.main.bounds.height * 0.85
    
    var numberOfColumns: Int = 4
    var numberOfRows: Int {
        Int(ceil(Double(viewModel.roundFaceParts.count)/Double(numberOfColumns)))
    }
    
    var feelingColor: Color { self.viewModel.faceIsCorrect() ? .TreeFrog :  .FireAnt }
    var borderName: String { self.viewModel.faceIsCorrect() ? "correct-border" : "wrong-border" }
    var iconName: String { self.viewModel.faceIsCorrect() ? "correct-icon" : "wrong-icon" }
    
    init(gameDifficulty: Difficulty, game: GameObject) {
        AppAnalytics.shared.logEvent(of: .launchGame, parameters: ["gameObject": game.gameName])
        self.viewModel = AvatarGameViewModel(game: game, difficulty: gameDifficulty)
    }
    
    var body: some View {
        
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            if !isFinished {
                
                Group {
                    //Nao olha isso chumiga
                    if showChatBalloon {
                        Rectangle()
                            .opacity(0)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                    withAnimation(.easeOut) {
                                        self.showChatBalloon = false
                                    }
                                }
                        }
                    }
                    
                    //POLVO
                    HStack {
                        VStack {
                            Spacer()
                            avatarImage()
                                .onReceive(self.viewModel.$confirmPressed) { (confirmPressed) in
                                    if confirmPressed {
                                        let image = self.avatarImage().asImage()
                                        self.viewModel.cropFaceOfAvatar(image: image)
                                    }
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    self.showChatBalloon = true
                                }
                            }
                        }.edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                    
                    //VStack geral
                    VStack {
                        
                        //Progress bar and leave button
                        ZStack {
                            if !isFinished {
                                HStack {
                                    Button(action: {
                                        self.showPopUp = true
                                    }) {
                                        Image(systemName: "xmark")
                                            .dynamicFont(name: "Rubik", size: 34, weight: .bold)
                                            .foregroundColor(.xMark)
                                    }.buttonStyle(PlainButtonStyle())
                                    
                                    Spacer()
                                }.padding(.leading, screenWidth*0.0385)
                            }
                            
                            HStack {
                                ProgressBarView(viewModel: progressViewModel)
                            }
                        }.padding(.top, screenWidth * 0.015)
                        .allowsHitTesting(!viewModel.confirmPressed)
                        
                        //Options
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 35) {
                                
                                CustomText("Selecione os elementos que correspondem\na como o Logginho está se sentindo:")
                                    .dynamicFont(size: 20, weight: .medium)
                                    .foregroundColor(.textColor)
                                    .multilineTextAlignment(.center)
                                
                                Grid<AvatarGameTile>(rows: numberOfRows, columns: numberOfColumns,
                                                     vSpacing: screenWidth * 0.02,
                                                     hSpacing: screenWidth * 0.006) { (row, column) in
                                    AvatarGameTile(facePart: self.viewModel.roundFaceParts[(row * self.numberOfColumns)+column],
                                                   eyeImage: self.$viewModel.eyeImage,
                                                   mouthImage: self.$viewModel.mouthImage,
                                                   eyebrowImage: self.$viewModel.eyebrowImage,
                                                   confirmPressed: self.$viewModel.confirmPressed)
                                }
                                
                                Spacer()
                            }
                            .padding(.trailing, screenWidth * 0.07)
                            .padding(.top, screenWidth * 0.125)
                        }.allowsHitTesting(!viewModel.confirmPressed)
                    }
                    
                    //Feedback massage
                    VStack {
                        Spacer()
                        ZStack {
                            if viewModel.canShowResult() {
                                GameFeedbackMessage(feedbackType: .CORRECT)
                                    .padding(.bottom, -(screenWidth * 0.035))
                            }
                        }
                    }
                    
                    // Confirm and Continue Buttons
                    VStack {
                        Spacer()
                        
                        if viewModel.canShowResult() {
                            // Continue Button
                            Button(action: {
                                self.confirmQuestion()
                            }) {
                                Text("Continuar")
                                    .dynamicFont(name: "Rubik", size: 20, weight: .bold)
                            }.buttonStyle(
                                self.viewModel.faceIsCorrect()
                                    ?
                                    //correct answer
                                    GameButtonStyle(buttonColor: Color.Owl,
                                                    pressedButtonColor: Color.Turtle,
                                                    buttonBackgroundColor: Color.TreeFrog,
                                                    isButtonEnable: viewModel.allOptionsSelected())
                                    :
                                    //wrong answer
                                    GameButtonStyle(buttonColor: Color.white,
                                                    pressedButtonColor: Color.Swan,
                                                    buttonBackgroundColor: Color.Swan,
                                                    isButtonEnable: viewModel.allOptionsSelected(),
                                                    textColor: Color.Humpback)
                            ).padding(.bottom, screenWidth * 0.019)
                        } else {
                            //Confirm Button
                            Button(action: {
                                self.viewModel.confirmPressed = true
                                self.showChatBalloon = true
                            }) {
                                Text("Confirmar")
                                    .dynamicFont(name: "Rubik", size: 20, weight: .bold)
                            }.buttonStyle(GameButtonStyle(buttonColor: Color.Whale,
                                                          pressedButtonColor: Color.Macaw,
                                                          buttonBackgroundColor: Color.Narwhal,
                                                          isButtonEnable: viewModel.allOptionsSelected())
                            ).disabled(!viewModel.allOptionsSelected())
                            .padding(.bottom, screenWidth * 0.019)
                        }
                    }
                    
                    ZStack {
                        Image("avatar-chat-balloon")
                            .resizable()
                            .frame(width: screenWidth * 0.34, height: screenWidth * 0.25)
                            .overlay(
                                ZStack {
                                    if viewModel.canShowResult() {
                                        Image(borderName)
                                            .resizable()
                                    }
                                    
                                    VStack {
                                        CustomText("ME SINTO")
                                            .dynamicFont(size: 18, weight: .medium)
                                            .foregroundColor(Color.Eel)
                                            .padding(.top, screenWidth * 0.04)
                                        
                                        CustomText("\(self.viewModel.feeling.rawValue)".uppercased())
                                            .dynamicFont(size: 25, weight: .bold)
                                            .foregroundColor(viewModel.canShowResult() ? self.feelingColor : .Humpback)
                                            .padding(.top, screenWidth * 0.03)
                                        Spacer()
                                    }
                                }
                            )
                        
                        if viewModel.canShowResult() {
                            Image(iconName)
                            .resizable()
                            .frame(width: self.screenWidth*0.043, height: self.screenWidth*0.043)
                            .padding(.leading, (screenWidth * 0.32))
                            .padding(.bottom, (screenWidth * 0.23))
                        }
                    }.opacity(showChatBalloon ? 1 : 0)
                    .padding(.trailing, screenWidth * 0.14)
                    .padding(.bottom, screenWidth * 0.33)
                }.blur(radius: self.showPopUp ? 16 : 0)
            } else {
                EndGameView(progressViewModel: self.progressViewModel,
                            dismissGame: self.dismissGame, restartGame: self.restartGame(game:),
                            game: self.viewModel.game, gameScore: self.viewModel.gameScore.currentScore)
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
        self.showPopUp = false
        self.showChatBalloon = true
        self.isFinished = false
        self.progressViewModel.restartProgressBar()
        self.viewModel.game = game
    }
    
    func confirmQuestion() {
        
        let index = self.progressViewModel.currentQuestion
        self.viewModel.ifWrongAddAnswer(with: index)
        
        self.viewModel.changeGameScore()
        
        if self.progressViewModel.isLastQuestion() && self.viewModel.gameState == .NORMAL {
            AppAnalytics.shared.logEvent(of: .gameRecap, parameters: ["recap_amount": viewModel.wrongAnswers.count, "gameObject": viewModel.game.gameName])
            self.viewModel.gameState = .RECAP
        }
        
        withAnimation(.linear(duration: 0.3)) {
            self.progressViewModel.checkAnswer(isCorrect: self.viewModel.faceIsCorrect(), nextIndex: self.viewModel.getRecapIndex())
        }
        
        self.viewModel.resetGame()
        
        if self.viewModel.gameState == .RECAP && self.viewModel.wrongAnswers.isEmpty {
            self.isFinished = true
            self.progressViewModel.currentQuestion = -1
        }
        
        self.viewModel.removeRecapGame()
        
        if !self.showChatBalloon {
            withAnimation(.easeInOut) {
                self.showChatBalloon = true
            }
        }
    }
    
}

extension AvatarGameView {
    
    func avatarImage() -> some View {
        Image("avatar-main-asset")
            .resizable()
            .frame(width: self.avatarWidth, height: self.avatarHeight)
            .overlay(
                VStack(spacing: 0) {
                    self.imageForEyebrow()
                        .padding(.top, self.screenWidth * 0.18)
                    self.imageForEye()
                        .padding(.top, -(self.screenWidth * 0.008))
                    self.imageForMouth()
                        .padding(.top, self.screenWidth * 0.01)
                    Spacer()
                }.padding(.trailing, self.screenWidth * 0.025)
        )
    }
    
    func imageForEyebrow() -> some View {
        Image(self.viewModel.eyebrowImage)
            .resizable()
            .frame(width: avatarWidth * 0.37, height: avatarWidth * 0.067)
    }
    
    func imageForEye() -> some View {
        Image(self.viewModel.eyeImage)
            .resizable()
            .frame(width: avatarWidth * 0.37, height: avatarWidth * 0.13)
    }
    
    func imageForMouth() -> some View {
        Image(self.viewModel.mouthImage)
            .resizable()
            .frame(width: avatarWidth * 0.15, height: avatarWidth * 0.13)
    }
}

struct AvatarGameTile: View {
    
    var facePart: FacePart
    
    @Binding var eyeImage: String
    @Binding var mouthImage: String
    @Binding var eyebrowImage: String
    @Binding var confirmPressed: Bool
    
    var isSelected: Bool {
        switch facePart.partOfFace {
        case .eye:
            return self.eyeImage == "avatar-eyes/\(facePart.image)"
        case .eyebrow:
            return self.eyebrowImage == "avatar-eyebrow/\(facePart.image)"
        case .mouth:
            return self.mouthImage == "avatar-mouth/\(facePart.image)"
        }
    }
    
    var screenWidth = UIScreen.main.bounds.width
    let tileWidth = UIScreen.main.bounds.width * 0.093
    let tileHeight = UIScreen.main.bounds.width * 0.084
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 15)
            .fill(isSelected ? Color.Bee : Color.clear)
            .frame(width: tileWidth * 1.17, height: tileWidth * 1.17)
            .offset(y: 4.5)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 165/255, green: 102/255, blue: 68/255))
                .frame(width: tileWidth, height: tileHeight)
                .offset(y: 9)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 255/255, green: 206/255, blue: 142/255))
                .frame(width: tileWidth, height: tileHeight)
            
            Image(imageName())
                .resizable()
                .frame(width: tileWidth * 0.85, height: tileWidth * 0.76)
            
        }.onTapGesture {
            self.changeFaceAsset()
        }
    }
    
    func imageName() -> String {
        switch facePart.partOfFace {
        case .eye:
            return "avatar-eyes-tile/\(facePart.image)"
        case .eyebrow:
            return "avatar-eyebrow-tile/\(facePart.image)"
        case .mouth:
            return "avatar-mouth-tile/\(facePart.image)"
        }
    }
    
    func changeFaceAsset() {
        switch facePart.partOfFace {
        case .eye:
            if self.eyeImage != "avatar-eyes/\(facePart.image)" {
                self.eyeImage = "avatar-eyes/\(facePart.image)"
            } else {
                self.eyeImage = ""
            }
            
        case .eyebrow:
            if self.eyebrowImage != "avatar-eyebrow/\(facePart.image)" {
                self.eyebrowImage = "avatar-eyebrow/\(facePart.image)"
            } else {
                self.eyebrowImage = ""
            }
            
        case .mouth:
            if self.mouthImage != "avatar-mouth/\(facePart.image)" {
                self.mouthImage = "avatar-mouth/\(facePart.image)"
            } else {
                self.mouthImage = ""
            }
        }
    }
}

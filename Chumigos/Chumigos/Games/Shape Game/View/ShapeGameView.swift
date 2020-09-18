//
//  ShapeGameNewView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ShapeGameView: View {
    
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Save the rects of all the questions
    @State private var questionsFrames: [(id: Int, rect: CGRect)] = []
    // Variable to know which alternative is being dragged
    @State private var alternativeBeingDragged: Int?
    
    @State var buttonIsPressed: Bool = false
    @State var isFinished: Bool = false
    @State var showPopUp: Bool = false
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    var game: GameObject
    
    private var tileSize: CGSize {
        let scaleFactor: CGFloat = self.viewModel.round.count > 9 ? 0.067 : 0.078
        return CGSize(width: screenWidth * scaleFactor, height: screenWidth * scaleFactor)
    }
    
    @ObservedObject var viewModel: ShapeGameViewModel
    
    init(gameDifficulty: Difficulty, game: GameObject) {
        self.viewModel = ShapeGameViewModel(difficulty: gameDifficulty)
        self.game = game
    }
    
    var body: some View {
        
        // Main stack
        ZStack {
            
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                if buttonIsPressed {
                    GameFeedbackMessage(feedbackType: viewModel.allQuestionsAreCorrect() ? .CORRECT : .WRONG)
                        .padding(.bottom, -40)
                }
            }
            
            
            if !isFinished {
                
                Group {
                    // Stack to separate forms and alternatives list
                    VStack {
                        
                        ZStack {
                            if !isFinished {
                                HStack {
                                    Button(action: {
                                        self.showPopUp = true
                                    }) {
                                        Image(systemName: "xmark")
                                            .dynamicFont(name: fontName, size: 34, weight: .bold)
                                            .foregroundColor(.xMark)
                                    }.buttonStyle(PlainButtonStyle())
                                    
                                    Spacer()
                                }.padding(.leading, screenWidth*0.0385)
                            }
                            
                            HStack {
                                ProgressBarView(viewModel: progressViewModel)
                            }
                        }.padding(.top, screenWidth * 0.015)
                        
                        Spacer()
                        
                        // Horizontal stack to show form pattern
                        HStack {
                            // Build every form in the horizontal based on parameters of pattern
                            ForEach(viewModel.round) { (element) in
                                // Cell that represents the pattern list as a form
                                self.patternView(for: element)
                            }
                        }.allowsHitTesting(buttonIsPressed ? false : true)

                        
                        Text("Complete a sequência arrastando as peças abaixo:")
                        .foregroundColor(Color.textColor)
                        .dynamicFont(name: fontName, size: 20, weight: .medium)
                        .padding(.top, screenWidth * 0.07)
                        
                        // Alternatives
                        HStack(spacing: screenWidth * 0.036) {
                            // Build every form in the horizontal based on parameters of pattern
                            ForEach(viewModel.alternatives) { (alternative) in
                                // Cell that represents the pattern list as a form
                                ZStack{
                                    //Underlay tile with opacity
                                    Tile(content: GenericForm(form: self.viewModel.difficultyForm, sides: alternative.value)
                                        .fill(self.viewModel.getRandomColors[alternative.colorIndex]).frame(width: self.screenWidth * 0.06, height: self.screenWidth * 0.06), size: self.tileSize)
                                        .alternativeBackground(size: self.tileSize)
                                        
                                    Tile(content: GenericForm(form: self.viewModel.difficultyForm, sides: alternative.value)
                                        .fill(self.viewModel.getRandomColors[alternative.colorIndex]).frame(width: self.screenWidth * 0.06, height: self.screenWidth * 0.06), size: self.tileSize)
                                        .draggable(onChanged: self.objectMoved, onEnded: self.objectDropped, answer: alternative.value)
                                    
                                }
                                // Make tile that is being drag appears on top
                                    .zIndex(self.alternativeBeingDragged == alternative.value ? 1: 0)
                            }
                        }.allowsHitTesting(buttonIsPressed ? false : true)
                        .padding(.top, screenWidth * 0.03)
                        
                        Spacer()
                        
                        ZStack {
                            //Continue Button
                            if buttonIsPressed {
                                Button(action: {
                                    self.checkQuestion()
                                }) {
                                    Text("Continuar")
                                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                                }.buttonStyle(
                                    viewModel.allQuestionsAreCorrect() ?
                                        //correct answer
                                        GameButtonStyle(buttonColor: Color.Owl, pressedButtonColor: Color.Turtle, buttonBackgroundColor: Color.TreeFrog, isButtonEnable: true) :
                                        //wrong answer
                                        GameButtonStyle(buttonColor: Color.white, pressedButtonColor: Color.Swan, buttonBackgroundColor: Color.Swan, isButtonEnable: true, textColor: Color.Humpback) )
                                    .padding(.bottom, 10)
                            }
                            else {
                                //Confirm Button
                                Button(action: {
                                    self.buttonIsPressed = true
                                }) {
                                    Text("Confirmar")
                                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                                }.buttonStyle(GameButtonStyle(buttonColor: Color.Whale, pressedButtonColor: Color.Macaw, buttonBackgroundColor: Color.Narwhal, isButtonEnable: self.viewModel.allQuestionsAreOccupied()))
                                    .disabled(!self.viewModel.allQuestionsAreOccupied())
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    
                    // Correct/Wrong Icons of which Question
                    ForEach(viewModel.questions) { (question) in
                        GeometryReader { geometry in
                            Image(question.isCorrect ? "correct-icon" : "wrong-icon")
                            .resizable()
                            .frame(width: self.tileSize.width*0.46, height: self.tileSize.width*0.46)
                            .offset(self.findOffset(for: question, geometry: geometry))
                            .opacity(self.buttonIsPressed ? 1 : 0)
                        }
                    }
                }.blur(radius: self.showPopUp ? 16 : 0)
                
            } else {
                EndGameView(progressViewModel: self.progressViewModel, dismissGame: self.dismissGame, restartGame: self.restartGame, game: self.game, gameScore: self.viewModel.gameScore.currentScore)
            }
            
            if self.showPopUp {
                ExitGamePopUp(showPopUp: self.$showPopUp, dismissGame: self.dismissGame)
            }
            
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    // MARK: - Finding question's position
    
    func findOffset(for question: Question, geometry: GeometryProxy) -> CGSize {
        if let matched = self.questionsFrames.first(where: { $0.id == question.correctAnswer }) {
            let x = geometry.frame(in: .global).midX.distance(to: matched.rect.midX) + tileSize.width/2.15
            let y = geometry.frame(in: .global).midY.distance(to: matched.rect.midY) - tileSize.height/2
            return CGSize(width: x, height: y)
        }
        return CGSize.zero
    }
    
    func dismissGame() {
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func restartGame() {
        self.viewModel.restartGame()
        self.questionsFrames = []
        self.isFinished = false
        self.progressViewModel.restartProgressBar()
    }
    
    func checkQuestion() {
        self.buttonIsPressed = false
        let index = self.progressViewModel.currentQuestion
        
        self.viewModel.verifyWrongQuestion(index: index)
        
        self.viewModel.changeGameScore()
        
        if self.progressViewModel.isLastQuestion()  && self.viewModel.gameState == .NORMAL {
            self.viewModel.gameState = .RECAP
        }
        
        withAnimation(.linear(duration: 0.3)) {
            self.progressViewModel.checkAnswer(isCorrect: self.viewModel.allQuestionsAreCorrect(), nextIndex: self.viewModel.getRecapIndex())
        }
        self.questionsFrames = []
        self.viewModel.resetGame(index: index)
        
        if self.viewModel.wrongAnswersArray.isEmpty && self.viewModel.gameState == .RECAP {
            self.isFinished = true
            self.progressViewModel.currentQuestion = -1
        }
        self.viewModel.removeRecapGame()
    }
    
    // MARK: - Drag & Drops Functions
    
    func objectMoved(location: CGPoint, alternative: Int) -> DragState {
        self.alternativeBeingDragged = alternative
        if let matchedFrame = questionsFrames.first(where: { $0.rect.contains(location) }) {
            if let _ = viewModel.questions.first(where: { $0.correctAnswer == matchedFrame.id && !$0.isOcupied }) {
                return .good
            }
        }
        return .unknown
    }
    
    func objectDropped(location: CGPoint, rect: CGRect, alternative: Int, dragState: DragState) -> (x: CGFloat, y: CGFloat) {
        self.alternativeBeingDragged = nil
        
        if dragState == .good {
            if let match = questionsFrames.firstIndex(where: {
                $0.rect.contains(location) }) {
                
                let newX = rect.midX.distance(to: questionsFrames[match].rect.midX)
                let newY = rect.midY.distance(to: questionsFrames[match].rect.midY)
                
                let newCGpoint = (x: newX, y: newY)
                
                if let matchedIndex = viewModel.questions.firstIndex(where: { $0.correctAnswer == questionsFrames[match].id }) {
                    viewModel.occupyQuestion(with: matchedIndex, alternative: alternative)
                }
                
                return newCGpoint
            }
        } else {
            for index in 0..<viewModel.questions.count {
                if viewModel.questions[index].currentAnswer == alternative {
                    viewModel.vacateQuestion(with: index)
                }
            }
        }
        return (x: CGFloat.zero, y: CGFloat.zero)
    }
}

extension ShapeGameView {
    
    func patternView(for piece: ShapeGameModel.ShapeForm) -> some View {
        ZStack {
            if !piece.isAQuestion {
                
                // Generic form to build sided forms
                Tile(content: GenericForm(form: self.viewModel.difficultyForm, sides: piece.sides)
                .fill(self.viewModel.getRandomColors[piece.colorIndex]).frame(width: self.screenWidth * 0.06, height: self.screenWidth * 0.06), size: self.tileSize)
                
            } else {
                
                // Form to guess
                QuestionTile(size: self.tileSize, isOccupied: self.viewModel.findQuestion(with: piece.sides)!.isOcupied, isCorrect: self.viewModel.findQuestion(with: piece.sides)!.isCorrect, buttonPressed: self.buttonIsPressed)
                    .overlay(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                let questionFrame = (id: piece.sides, rect: geo.frame(in: .global))
                                self.questionsFrames.append(questionFrame)
                        }
                    })
            }
        }
    }
}



//struct ShapeGameNewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShapeGameView(gameDifficulty: Difficulty.medium)
//    }
//}

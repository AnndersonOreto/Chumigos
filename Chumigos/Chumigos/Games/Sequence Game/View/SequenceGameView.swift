//
//  StudyingView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 11/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct SequenceGameView: View {
    
    @ObservedObject var viewModel = SequenceGameViewModel()
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 2)
    
    // Save the rects of all the questions
    @State private var questionsFrames: [(question: Question, rect: CGRect)] = []
    // Variable to know which alternative is being dragged
    @State private var alternativeBeingDragged: Int?
    // Variable to know if the button is pressed or not
    @State var buttonIsPressed: Bool = false
    @State var isFinished: Bool = false
    @State var showPopUp: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var tileSize: CGSize {
        let scaleFactor: CGFloat = self.viewModel.sequence.count > 9 ? 0.067 : 0.078
        return CGSize(width: screenWidth * scaleFactor, height: screenWidth * scaleFactor)
    }
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                if buttonIsPressed {
                    GameFeedbackMessage(feedbackType: viewModel.allQuestionsAreCorrect() ? .CORRECT : .WRONG)
                        .padding(.bottom, -(screenWidth * 0.035))
                }
            }
            
            if !self.isFinished {
                Group{
                    VStack(spacing: 0) {
                        
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
                        
                        
                        HStack(spacing: 0) {
                            ForEach(viewModel.sequence) { element in
                                self.pieceView(for: element)
                            }
                        }.allowsHitTesting(buttonIsPressed ? false : true)

                        
                        Text("Complete a sequência arrastando as peças abaixo:")
                            .foregroundColor(.textColor)
                            .dynamicFont(name: fontName, size: 20, weight: .medium)
                            .padding(.top, screenWidth * 0.07)
                        
                        HStack(spacing: screenWidth * 0.036) {
                            ForEach(viewModel.alternatives) { (alternative) in
                                ZStack{
                                    //Underlay tile with opacity
                                    Tile(content: Image(alternative.content).resizable(), size: self.tileSize)
                                        .alternativeBackground(size: self.tileSize)
                                    
                                    Tile(content: Image(alternative.content).resizable(), size: self.tileSize)
                                        .draggable(onChanged: self.objectMoved, onEnded: self.objectDropped, answer: alternative.value)
                                    
                                }
                                    // Make tile that is being drag appears on top
                                    .zIndex(self.alternativeBeingDragged == alternative.value ? 1 : 0)
                            }
                        }.padding(.top, screenWidth * 0.03)
                        .allowsHitTesting(buttonIsPressed ? false : true)
                        
                        Spacer()
                        
                        ZStack {
                            //Continue Button
                            if buttonIsPressed {
                                Button(action: {
                                    self.confirmQuestion()
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
                EndGameView(progressViewModel: self.progressViewModel, dismissGame: self.dismissGame, restartGame: self.restartGame)
            }
            
            if self.showPopUp {
                ExitGamePopUp(showPopUp: self.$showPopUp, dismissGame: self.dismissGame)
            }
            
            }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    // MARK: - Drawing Contants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    // MARK: - Finding question's position
    
    func findOffset(for question: Question, geometry: GeometryProxy) -> CGSize {
        if let matched = self.questionsFrames.first(where: { $0.question.id == question.id }) {
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
    
    func confirmQuestion() {
        
        self.buttonIsPressed = false
        let index = self.progressViewModel.currentQuestion
        
        self.viewModel.verifyWrongQuestion(index: index)
        
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
            if let _ = viewModel.questions.first(where: { $0.correctAnswer == matchedFrame.question.correctAnswer && !$0.isOcupied }) {
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
                
                if let matchedIndex = viewModel.questions.firstIndex(where: { $0.correctAnswer == questionsFrames[match].question.correctAnswer }) {
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

// MARK: - View Extension

extension SequenceGameView {
    
    // MARK: - View for the Tile/Piece
    private func pieceView(for piece: SequenceGameModel.SequencePiece) -> some View {
        ZStack {
            if piece.isAQuestion {
                QuestionTile(size: self.tileSize, isOccupied: self.viewModel.findQuestion(with: piece.value)!.isOcupied, isCorrect: self.viewModel.findQuestion(with: piece.value)!.isCorrect, buttonPressed: self.buttonIsPressed)
                    .overlay(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                let questionFrame = (question: self.viewModel.findQuestion(with: piece.value)!, rect: geo.frame(in: .global))
                                self.questionsFrames.append(questionFrame)
                        }
                    })
            }
            else {
                Tile(content: Image(piece.content).resizable(), size: self.tileSize)
            }
        }
    }
}


struct StudyingView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceGameView()
    }
}

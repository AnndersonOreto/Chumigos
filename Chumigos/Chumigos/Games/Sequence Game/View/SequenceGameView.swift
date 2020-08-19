//
//  StudyingView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 11/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct SequenceGameView: View {
    
    var viewModel = SequenceGameViewModel()
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    
    // Save the rects of all the questions
    @State private var questionsFrames: [(question: Question, rect: CGRect)] = []
    // Variable to know which alternative is being dragged
    @State private var alternativeBeingDragged: Int?
    // Variable to know if the button is pressed or not
    @State var buttonIsPressed: Bool = false
    
    private var tileSize: CGSize {
        let scaleFactor: CGFloat = self.viewModel.sequence.count > 9 ? 0.067 : 0.078
        return CGSize(width: screenWidth * scaleFactor, height: screenWidth * scaleFactor)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                ProgressBarView(viewModel: progressViewModel)
                
                Spacer()
                
                
                HStack(spacing: 0) {
                    ForEach(viewModel.sequence) { element in
                        self.pieceView(for: element)
                    }
                }
                
                Text("Complete a sequência arrastando as peças abaixo:")
                    .foregroundColor(Color.Eel)
                    .font(.custom(fontName, size: screenWidth * 0.016)).fontWeight(.medium)
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
                
                Spacer()
                
                Button(action: {
                    if self.viewModel.allQuestionsAreOccupied() {
                        self.questionsFrames = []
                        self.viewModel.resetGame()
                        withAnimation(.linear(duration: 0.3)) {
                            self.progressViewModel.checkAnswer(isCorrect: self.viewModel.allQuestionsAreCorrect())
                        }
                        self.buttonIsPressed = true
                    }
                }) {
                    Text("Confirmar")
                        .font(.custom(fontName, size: 20)).bold()
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Whale, pressedButtonColor: Color.Macaw, buttonBackgroundColor: Color.Narwhal))
                    .padding(.bottom, 23)
            }
            
            // Correct/Wrong Icons of which Question
            ForEach(viewModel.questions) { (question) in
                Image(question.isCorrect ? "correct-icon" : "wrong-icon")
                    .resizable()
                    .frame(width: self.tileSize.width*0.46, height: self.tileSize.width*0.46)
                    .position(self.findPosition(for: question))
                    .opacity(self.buttonIsPressed ? 1 : 0)
            }
        }
    }
    
    // MARK: - Drawing Contants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    // MARK: - Finding question's position
    
    // TODO: - Ajeitar para todos os iPads
    // Valores funcionam para iPad 12.9
    func findPosition(for question: Question) -> CGPoint {
        if let matched = self.questionsFrames.first(where: { $0.question.id == question.id }) {
            let scale: CGFloat = viewModel.sequence.count > 9 ? 1.2 : 1.03
            let x = matched.rect.maxX - tileSize.width/5
            let y = matched.rect.origin.y - tileSize.height*scale
            return CGPoint(x: x, y: y)
        }
        return CGPoint.zero
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
    private func pieceView(for piece: SequenceGameModel<String>.SequencePiece) -> some View {
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

//
//  ShapeGameNewView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ShapeGameView: View {
    
    @ObservedObject var viewModel = ShapeGameViewModel()
    @ObservedObject var progressBarViewModel = ProgressBarViewModel(questionAmount: 5)
    
    // Save the rects of all the questions
    @State private var questionsFrames: [(id: Int, rect: CGRect)] = []
    // Variable to know which alternative is being dragged
    @State private var alternativeBeingDragged: Int?
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    private var tileSize: CGSize {
        let scaleFactor: CGFloat = self.viewModel.round.count > 9 ? 0.067 : 0.078
        return CGSize(width: screenWidth * scaleFactor, height: screenWidth * scaleFactor)
    }
    
    var body: some View {
        
        // Main stack
        ZStack {
            // Stack to separate forms and alternatives list
            VStack {
                
                ProgressBarView(viewModel: self.progressBarViewModel)
                
                Spacer()
                
                // Horizontal stack to show form pattern
                HStack {
                    // Build every form in the horizontal based on parameters of pattern
                    ForEach(viewModel.round) { (element) in
                        // Cell that represents the pattern list as a form
                        self.patternView(for: element)
                    }
                }
                
                Text("Complete a sequência arrastando as peças abaixo:")
                .foregroundColor(Color.Eel)
                .font(.custom(fontName, size: screenWidth * 0.016)).fontWeight(.medium)
                .padding(.top, screenWidth * 0.07)
                
                // Alternatives
                HStack(spacing: screenWidth * 0.036) {
                    // Build every form in the horizontal based on parameters of pattern
                    ForEach(viewModel.alternatives) { (alternative) in
                        // Cell that represents the pattern list as a form
                        ZStack{
                            //Underlay tile with opacity
                            Tile(content: GenericForm(form: self.viewModel.difficultyForm, sides: alternative.sides)
                            .fill(self.viewModel.randomColors[alternative.colorIndex]), size: self.tileSize)
                                .alternativeBackground(size: self.tileSize)
                                
                            Tile(content: GenericForm(form: self.viewModel.difficultyForm, sides: alternative.sides)
                                .fill(self.viewModel.randomColors[alternative.colorIndex]), size: self.tileSize)
                                .draggable(onChanged: self.objectMoved, onEnded: self.objectDropped, answer: alternative.sides)
                            
                        }
                        // Make tile that is being drag appears on top
                        .zIndex(self.alternativeBeingDragged == alternative.sides ? 1: 0)
                    }
                }.padding(.top, screenWidth * 0.03)
                
                Spacer()
                
                Button(action: {
                    if self.viewModel.allQuestionsAreCorrect() {
                        print("correto")
                        self.questionsFrames = []
                        self.viewModel.resetGame()
                        withAnimation(.linear(duration: 0.3)) {
                            self.progressBarViewModel.checkAnswer(isCorrect: true)
                        }
                    } else {
                        print("errado")
                        self.questionsFrames = []
                        self.viewModel.resetGame()
                        withAnimation(.linear(duration: 0.3)) {
                            self.progressBarViewModel.checkAnswer(isCorrect: false)
                        }
                    }
                }) {
                    Text("Confirmar")
                        .font(.custom(fontName, size: 20)).bold()
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Whale, pressedButtonColor: Color.Macaw, buttonBackgroundColor: Color.Narwhal, isButtonDisabled: self.viewModel.allQuestionsAreOccupied()))
                    .disabled(!self.viewModel.allQuestionsAreOccupied())
                    .padding(.bottom, 23)
            }
        }
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
    func patternView(for piece: ShapeGameModel.Shape) -> some View {
        ZStack {
            if !piece.isAQuestion {
                
                // Generic form to build sided forms
                Tile(content: GenericForm(form: self.viewModel.difficultyForm, sides: piece.sides)
                    .fill(self.viewModel.randomColors[piece.colorIndex]), size: self.tileSize)
            } else {
                
                // Form to guess
                QuestionTile(size: self.tileSize)
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



struct ShapeGameNewView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeGameView()
    }
}

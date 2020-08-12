//
//  StudyingView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 11/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct StudyingView: View {
    
    @ObservedObject var viewModel = SequenceGameViewModel()
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    @State var questionsFrames: [(id: Int, rect: CGRect)] = []
    @State var alternativeSelected: Int?
    
    var tileSize: CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor: CGFloat = self.viewModel.sequence.count > 9 ? 0.067 : 0.078
        return CGSize(width: screenWidth * scaleFactor, height: screenWidth * scaleFactor)
    }
    
    
    var body: some View {
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
                .font(.custom("Rubik", size: UIScreen.main.bounds.width * 0.016)).fontWeight(.medium)
                .padding(.top, UIScreen.main.bounds.width * 0.07)
            
            HStack(spacing: UIScreen.main.bounds.width * 0.036) {
                ForEach(viewModel.alternatives) { (alternative) in
                    ZStack{
                        //Underlay tile with opacity
                        BackgroundAlternative(content: {
                            Tile(image: alternative.content, size: self.tileSize)
                        }, size: self.tileSize)
                        
                        DraggableObject(content: {
                            Tile(image: alternative.content, size: self.tileSize)
                        }, onChanged: self.objectMoved, onEnded: self.objectDropped, answer: alternative.value)
                    }.zIndex(self.alternativeSelected == alternative.value ? 1: 0)
                }
            }.padding(.top, UIScreen.main.bounds.width * 0.03)
            
            Spacer()
            
            Button(action: {
                if self.viewModel.allQuestionsAreCorrect() {
                    self.questionsFrames = []
                    self.viewModel.resetGame()
                    self.progressViewModel.checkAnswer(isCorrect: true)
                }
            }) {
                Text("Confirmar")
                    .font(.custom("Rubik", size: 20)).bold()
            }.buttonStyle(GameButtonStyle(buttonColor: Color.Whale, pressedButtonColor: Color.Macaw, buttonBackgroundColor: Color.Narwhal))
                .padding(.bottom, 23)
        }
    }
    
    func objectMoved(location: CGPoint, alternative: Int) -> DragState {
        self.alternativeSelected = alternative
        if let matchedFrame = questionsFrames.first(where: { $0.rect.contains(location) }) {
            if let _ = viewModel.questions.first(where: { $0.value == matchedFrame.id && !$0.isOcupied }) {
                return .good
            }
        }
        return .unknown
    }
    
    func objectDropped(location: CGPoint, rect: CGRect, alternative: Int, dragState: DragState) -> (x: CGFloat, y: CGFloat) {
        self.alternativeSelected = nil
        
        if dragState == .good {
            if let match = questionsFrames.firstIndex(where: {
                $0.rect.contains(location) }) {
                
                let newX = rect.midX.distance(to: questionsFrames[match].rect.midX)
                let newY = rect.midY.distance(to: questionsFrames[match].rect.midY)
                
                let newCGpoint = (x: newX, y: newY)
                
                if let matchedIndex = viewModel.questions.firstIndex(where: { $0.value == questionsFrames[match].id }) {
                    viewModel.occupyQuestion(with: matchedIndex, alternative: alternative)
                }
                
                return newCGpoint
            }
        } else {
            for index in 0..<viewModel.questions.count {
                if viewModel.questions[index].occupant == alternative {
                    viewModel.vacateQuestion(with: index)
                }
            }
        }
        return (x: CGFloat.zero, y: CGFloat.zero)
    }
}

extension StudyingView {
    private func pieceView(for piece: SequenceGameModel<String>.SequencePiece) -> some View {
        ZStack {
            if piece.isAQuestion {
                QuestionTile(size: self.tileSize)
                    .overlay(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                let questionFrame = (id: piece.value, rect: geo.frame(in: .global))
                                self.questionsFrames.append(questionFrame)
                        }
                    })
            }
            else {
                Tile(image: piece.content, size: self.tileSize)
            }
        }
    }
}


struct StudyingView_Previews: PreviewProvider {
    static var previews: some View {
        StudyingView()
    }
}

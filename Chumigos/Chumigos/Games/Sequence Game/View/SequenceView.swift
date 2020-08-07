//
//  MarcusSequenceView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 31/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct SequenceView: View {
    
    @ObservedObject var viewModel = SequenceViewModel(difficulty: .MEDIUM)
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    @State var answersFrames: [(rect: CGRect, answer: Int, alternative: Int)] = []
    
    var tileSize: CGSize {
        return self.viewModel.sequence.count > 9 ?
            CGSize(width: UIScreen.main.bounds.width * 0.067, height: UIScreen.main.bounds.width * 0.067) :
            CGSize(width: UIScreen.main.bounds.width * 0.078, height: UIScreen.main.bounds.width * 0.078)
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            ProgressBarView(viewModel: progressViewModel)
            
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(viewModel.sequence.indices, id: \.self) { index in
                    SequenceRectangle(size: self.tileSize, index: index, number: self.viewModel.sequence[index].value, viewModel: self.viewModel, answersFrames: self.$answersFrames)
                }
            }
            
            Text("Complete a sequência arrastando as peças abaixo:")
                .foregroundColor(Color.eelColor)
                .font(.custom("Rubik", size: UIScreen.main.bounds.width * 0.016)).fontWeight(.medium)
                .padding(.top, UIScreen.main.bounds.width * 0.07)
            
            HStack(spacing: UIScreen.main.bounds.width * 0.036) {
                ForEach(viewModel.alternatives.indices, id: \.self) { index in
                    
                    ZStack{
                        //Underlay tile with opacity
                        BackgroundAlternative(content: {
                            Tile(image: self.viewModel.alternatives[index].asset, size: self.tileSize)
                        }, size: self.tileSize)
                        
                        DraggableObject(content: {
                            Tile(image: self.viewModel.alternatives[index].asset, size: self.tileSize)
                        }, onChanged: self.objectMoved, onEnded: self.objectDropped, answer: self.viewModel.alternatives[index].value)
                    }
                }
            }.padding(.top, UIScreen.main.bounds.width * 0.03)
            
            Spacer()
            
            Button(action: {
                if self.viewModel.checkAnswer(answerTuple: self.answersFrames) {
                    self.answersFrames = []
                    self.progressViewModel.checkAnswer(isCorrect: true)
                }
            }) {
                Text("Confirmar")
                    .font(.custom("Rubik", size: 20)).bold()
            }.buttonStyle(GameButtonStyle(buttonColor: Color.regularBlue, pressedButtonColor: Color.lightBlue, buttonBackgroundColor: Color.darkBlue))
                .padding(.bottom, 23)
        }.id(UUID())
    }
    
    func objectMoved(location: CGPoint) -> DragState {
        
        if answersFrames.firstIndex(where: {
            $0.rect.contains(location) && $0.alternative == 0}) != nil {
            return .good
        } else {
            return .unknown
        }
    }
    
    func objectDropped(location: CGPoint, rect: CGRect, alternative: Int, dragState: DragState) -> (x: CGFloat, y: CGFloat) {
        
        if dragState == .good {
            if let match = answersFrames.firstIndex(where: {
                $0.rect.contains(location) }) {
                
                let newX = rect.midX.distance(to: answersFrames[match].rect.midX)
                let newY = rect.midY.distance(to: answersFrames[match].rect.midY)
                
                let newCGpoint = (x: newX, y: newY)
                
                for i in 0..<answersFrames.count {
                    if answersFrames[i].alternative == alternative {
                        answersFrames[i].alternative = 0
                    }
                }
            
                answersFrames[match].alternative = alternative
                
                return newCGpoint
            }
        } else {
            for i in 0..<answersFrames.count {
                if answersFrames[i].alternative == alternative {
                    answersFrames[i].alternative = 0
                }
            }
        }
        
        return (x: CGFloat.zero, y: CGFloat.zero)
    }
}

struct SequenceRectangle: View {
    
    let size: CGSize
    var index: Int
    var number: Int
    @ObservedObject var viewModel: SequenceViewModel
    @Binding var answersFrames: [(rect: CGRect, answer: Int, alternative: Int)]
    
    var body: some View {
        ZStack {
            if number == -1 {
                QuestionTile(size: self.size)
                    .overlay(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                self.answersFrames.append((rect: geo.frame(in: .global), answer: self.getCorrectAnswer(), alternative: 0))
                        }
                    })
            }
            else {
                Tile(image: self.viewModel.sequence[index].asset, size: self.size)
            }
        }
        
    }
    
    func getCorrectAnswer() -> Int {
        let size = self.viewModel.functions.getSize()
        var multiplier = 0
        var aux = 0

        if index < size {
            aux = index
        } else if index < size*2 {
            multiplier = 1
        } else if index < size*3 {
            multiplier = 2
        } else {
            multiplier = 3
        }

        aux = index - (size * multiplier)
        return self.viewModel.sequence[aux].value
    }
        
}


struct MarcusSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceView()
    }
}

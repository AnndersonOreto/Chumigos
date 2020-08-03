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
    
    @State var answersFrames: [(rect: CGRect, answer: Int, alternative: Int)] = []
    
    
    var body: some View {
        VStack(spacing: 80) {
            
            HStack {
                ForEach(viewModel.sequence.indices, id: \.self) { index in
                    SequenceRectangle(index: index, number: self.viewModel.sequence[index], viewModel: self.viewModel, answersFrames: self.$answersFrames)
                }
            }
            HStack {
                ForEach(viewModel.alternatives.indices, id: \.self) { index in
//                    DraggableObject(onChanged: self.objectMoved, onEnded: self.objectDropped)
                    DraggableObject(content: {
                        Rectangle().fill(self.getRandomColor(number: self.viewModel.alternatives[index])).frame(width: 70, height: 70)
                    }, onChanged: self.objectMoved, onEnded: self.objectDropped, answer: self.viewModel.alternatives[index])
                }
            }
            Button(action: {
                if self.viewModel.checkAnswer(answerTuple: self.answersFrames) {
                    self.answersFrames = []
                }
            }) {
                Text("confirm")
            }
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
    
    func getRandomColor(number: Int) -> Color {
        switch number {
        case 1:
            return Color.blue
        case 2:
            return Color.orange
        case 3:
            return Color.red
        case 4:
            return Color.yellow
        case 5:
            return Color.green
        default:
            return Color.black
        }
    }
}

struct SequenceRectangle: View {
    
    var index: Int
    var number: Int
    @ObservedObject var viewModel: SequenceViewModel
    @Binding var answersFrames: [(rect: CGRect, answer: Int, alternative: Int)]
    
    var body: some View {
        ZStack {
            if number == -1 {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 70, height: 70)
                    .overlay(GeometryReader { geo in
                        Color.darkPurple
                            .onAppear {
                                self.answersFrames.append((rect: geo.frame(in: .global), answer: self.getCorrectAnswer(), alternative: 0))
                        }
                    })
            }
            else {
                Rectangle()
                    .fill(getRandomColor())
                    .frame(width: 70, height: 70)
            }
        }
        
    }
    
    func getRandomColor() -> Color {
        switch number {
        case 1:
            return Color.blue
        case 2:
            return Color.orange
        case 3:
            return Color.red
        case 4:
            return Color.yellow
        case 5:
            return Color.green
        default:
            return Color.black
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
        return self.viewModel.sequence[aux]
    }
        
}


//struct MarcusSequenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MarcusSequenceView()
//    }
//}

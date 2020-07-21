//
//  SequenceView.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct SequenceView: View {
    
    let functions = Functions()
    @State var questionRect: CGRect = .zero
    
    @ObservedObject var viewModel = SequenceViewModel()
    
    var body: some View {
        VStack(spacing: 80) {
            HStack {
                ForEach(createFunc(), id: \.self) { element in
                    SequenceRectangle(number: element, questionRect: self.$questionRect)
                }
            }
            HStack {
                ForEach(generateAlternatives(), id: \.self) { element in
                    DraggableAlternative(rightPlace: self.questionRect, viewModel: self.viewModel, answer: element)
                }
            }
        }
    }
    
    func createFunc() -> [Int] {
        let sequence = functions.generateSequence(diff: .EASY)
        return generateQuestion(sequence: sequence, difficulty: .EASY)
    }
    
    func generateQuestion(sequence: [Int], difficulty: DIFFICULT) -> [Int] {
        var questionSequence = sequence
        switch difficulty {
        case .EASY:
            let random = Int.random(in: functions.getSize()..<sequence.count)
            viewModel.correctAnswer.append(sequence[random])
            questionSequence[random] = -1
            return questionSequence
        case .MEDIUM:
            let random1 = Int.random(in: functions.getSize()..<sequence.count)
            var random2: Int
            repeat {
                random2 = Int.random(in: functions.getSize()..<sequence.count)
            } while random1 == random2
            
            viewModel.correctAnswer.append(sequence[random1])
            viewModel.correctAnswer.append(sequence[random2])
            
            questionSequence[random1] = -1
            questionSequence[random2] = -1
            
            return questionSequence
        default:
            return []
        }
    }
    
    func generateAlternatives() -> [Int] {
        var sequence = functions.getPattern()
        sequence.shuffle()
        return sequence
    }
}

struct SequenceRectangle: View {
    var number: Int
    @Binding var questionRect: CGRect
    
    var body: some View {
        ZStack {
            if number == -1 {
                Text("?")
                    .padding()
                    .border(Color.black)
                    .background(GeometryGetter(rect: $questionRect))
            }
            else {
                Rectangle()
                    .fill(getRandomColor())
                    .frame(width: 50, height: 50)
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
}

struct SequenceView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceView()
    }
}

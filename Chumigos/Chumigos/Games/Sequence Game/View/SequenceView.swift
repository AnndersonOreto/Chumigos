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
    
    var body: some View {
        VStack {
            HStack {
                ForEach(createFunc(), id: \.self) { element in
                    SequenceRectangle(number: element)
                }
            }
        }
    }
    
    func createFunc() -> [Int] {
        var sequence = functions.generateSequence(diff: .EASY)
        return generateQuestion(sequence: sequence)
    }
    
    func generateQuestion(sequence: [Int]) -> [Int] {
        var questionSequence = sequence
        let random = Int.random(in: functions.getSize()..<sequence.count)
        questionSequence[random] = -1
        print(questionSequence)
        return questionSequence
    }
}

struct SequenceRectangle: View {
    var number: Int
    
    var body: some View {
        ZStack {
            if number == -1 {
                Text("?")
                    .padding()
                    .border(Color.black)
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

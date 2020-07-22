//
//  SequenceViewModel.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CoreGraphics

class SequenceViewModel: ObservableObject {
    
    let functions = Functions()
    
    var correctAnswers: [Int] = []
    var answersRect: [CGRect] = []
    var answersTupla: [(answer: Int, rect: CGRect)] = []
    var sequence: [Int] = []
    var alternatives: [Int] = []
    
    init() {
        createFunc()
        generateAlternatives()
    }
    
    func createFunc() {
        let seq = functions.generateSequence(diff: .HARD)
        self.sequence = generateQuestion(sequence: seq, difficulty: .HARD)
    }
    
    func generateQuestion(sequence: [Int], difficulty: DIFFICULT) -> [Int] {
        var questionSequence = sequence
        switch difficulty {
        case .EASY:
            let random = Int.random(in: functions.getSize()..<sequence.count)
            correctAnswers.append(sequence[random])
            questionSequence[random] = -1
            return questionSequence
        case .MEDIUM:
            let random1 = Int.random(in: functions.getSize()..<sequence.count)
            var random2: Int
            repeat {
                random2 = Int.random(in: functions.getSize()..<sequence.count)
            } while sequence[random1] == sequence[random2]
            
            correctAnswers.append(sequence[random1])
            correctAnswers.append(sequence[random2])
            
            questionSequence[random1] = -1
            questionSequence[random2] = -1
            
            return questionSequence
        default:
            let random1 = Int.random(in: functions.getSize()..<sequence.count)
            var random2: Int
            var random3: Int
            
            repeat {
                random2 = Int.random(in: functions.getSize()..<sequence.count)
                random3 = Int.random(in: functions.getSize()..<sequence.count)
            } while (sequence[random1] == sequence[random2] &&
                sequence[random1] == sequence[random3] &&
                sequence[random2] == sequence[random3])
            
            correctAnswers.append(sequence[random1])
            correctAnswers.append(sequence[random2])
            correctAnswers.append(sequence[random3])
            
            questionSequence[random1] = -1
            questionSequence[random2] = -1
            questionSequence[random3] = -1
            
            return questionSequence
        }
    }
    
    func generateAlternatives() {
        var pattern = functions.getPattern()
        pattern.shuffle()
        self.alternatives = pattern
    }
}

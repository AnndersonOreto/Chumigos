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
    
    @Published var sequence: [SequenceTile] = []
    @Published var alternatives: [SequenceTile] = []
    
    var correctAnswers: [Int] = []
    var answers: [(answer: Int, rect: CGRect, rectID: Int)] = []
    var amountOfCorrectAnswers: Int = 0
    var rounds: Int = 0
    
    
    init(difficulty: DIFFICULT) {
        createFunc(difficulty: difficulty)
    }
    
    func createFunc(difficulty: DIFFICULT) {
        self.resetRound()
        let seq = functions.generateSequence(diff: difficulty)
        self.sequence = generateQuestion(sequence: seq, difficulty: difficulty)
        self.generateAlternatives()
    }
    
    func generateQuestion(sequence: [Int], difficulty: DIFFICULT) -> [SequenceTile] {
        
        var questionSequence:[SequenceTile] = []
        let random = Bool.random()
        
        for item in sequence {
            if random {
                questionSequence.append(SequenceTile(value: item, asset: "fruit-\(item)"))
            } else {
                questionSequence.append(SequenceTile(value: item, asset: "shape-\(item)"))
            }
        }
        
        switch difficulty {
        case .EASY:
            let random = Int.random(in: functions.getSize()..<sequence.count)
            correctAnswers.append(sequence[random])
            questionSequence[random] = SequenceTile(value: -1, asset: "")
            return questionSequence
        case .MEDIUM:
            let random1 = Int.random(in: functions.getSize()..<sequence.count)
            var random2: Int
            repeat {
                random2 = Int.random(in: functions.getSize()..<sequence.count)
            } while sequence[random1] == sequence[random2]
            
            correctAnswers.append(sequence[random1])
            correctAnswers.append(sequence[random2])
            
            questionSequence[random1] = SequenceTile(value: -1, asset: "")
            questionSequence[random2] = SequenceTile(value: -1, asset: "")
            
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
            
            questionSequence[random1] = SequenceTile(value: -1, asset: "")
            questionSequence[random2] = SequenceTile(value: -1, asset: "")
            questionSequence[random3] = SequenceTile(value: -1, asset: "")
            
            return questionSequence
        }
    }
    
    func checkAnswer(answerTuple: [(rect: CGRect, answer: Int, alternative: Int)]) -> Bool{
        for element in answerTuple {
            print(element)
            if element.alternative == element.answer {
                incrementCorrectAnswers()
            }
        }
        return self.checkRoundFinished()
    }
    
    func generateAlternatives() {
        var pattern = functions.getPattern()
        pattern.shuffle()
        for item in pattern {
            if let match = sequence.firstIndex(where: {
                $0.value == item }) {
                self.alternatives.append(SequenceTile(value: sequence[match].value, asset: sequence[match].asset))
            }
        }
    }
    
    func incrementCorrectAnswers() {
        self.amountOfCorrectAnswers += 1
    }
    
    func checkRoundFinished() -> Bool{
        switch self.functions.getDifficulty() {
        case .EASY:
            if self.amountOfCorrectAnswers == 1 {
                print("ROUND EASY FINISHED!")
                self.incrementRounds()
                self.createFunc(difficulty: .MEDIUM)
                return true
            }
        case .MEDIUM:
            if self.amountOfCorrectAnswers == 2 {
                print("ROUND MEDIUM FINISHED!")
                self.incrementRounds()
                self.createFunc(difficulty: .EASY)
                return true
            }
        case .HARD:
            if self.amountOfCorrectAnswers == 3 {
                print("ROUND HARD FINISHED!")
                self.incrementRounds()
                return true
            }
        }
        return false
    }
    
    func incrementRounds() {
        self.rounds += 1
        self.checkGameFinished()
    }
    
    func checkGameFinished() {
        if self.rounds == 5 {
            print("GAME FINISHED!")
        }
    }
    
    func resetRound() {
        self.sequence = []
        self.alternatives = []
        self.correctAnswers = []
        self.answers = []
        self.amountOfCorrectAnswers = 0
    }
}

struct SequenceTile {
    let value: Int
    let asset: String
}

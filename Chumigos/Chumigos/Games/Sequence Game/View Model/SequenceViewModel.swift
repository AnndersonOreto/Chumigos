//
//  SequenceViewModel.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CoreGraphics

class SequenceViewModel: ObservableObject, GameViewModelProtocol {

    func verify() -> Bool {
        return true
    }
    
    let functions = Functions()
    
    @Published var sequence: [Int] = []
    @Published var alternatives: [Int] = []
    
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
    
    func incrementCorrectAnswers() {
        self.amountOfCorrectAnswers += 1
        self.checkRoundFinished()
    }
    
    func checkRoundFinished() {
        switch self.functions.getDifficulty() {
        case .EASY:
            if self.amountOfCorrectAnswers == 1 {
                print("ROUND EASY FINISHED!")
                self.incrementRounds()
                self.createFunc(difficulty: .MEDIUM)
            }
        case .MEDIUM:
            if self.amountOfCorrectAnswers == 2 {
                print("ROUND MEDIUM FINISHED!")
                self.incrementRounds()
                self.createFunc(difficulty: .EASY)
            }
        case .HARD:
            if self.amountOfCorrectAnswers == 3 {
                print("ROUND HARD FINISHED!")
                self.incrementRounds()
            }
        }
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

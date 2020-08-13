//
//  ShapeGameModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

struct ShapeGameModel {
    private(set) var alternatives: [Shape] = []
    private(set) var questions: [Question] = []
    private(set) var round: [Shape] = []
    
    private let amount: Int = 4
    private let isAscending: Bool = Bool.random()
    
    private let difficulty: Difficulty
    
    init(difficulty: Difficulty = .easy) {
        self.difficulty = difficulty
        generateRound()
        generateQuestions()
        generateAlternatives()
    }
    
    // MARK: - Functions to Generate the Variables
    
    private mutating func generateRound() {
        let range = isAscending ? 3..<6 : 6..<9
        let initialNumberOfSides = Int.random(in: range)
        for index in 0..<amount {
            let value = isAscending ? index : -index
            round.append(Shape(sides: initialNumberOfSides+value, colorIndex: index))
        }
    }
    
    private mutating func generateQuestions() {
        let questionIndex = Int.random(in: 0..<round.count)
        questions.append(Question(correctAnswer: round[questionIndex].sides))
        round[questionIndex].isAQuestion = true
    }
    
    private mutating func generateAlternatives() {
        var range = Array(3...12)
        let question = questions.first!
        
        for index in 0..<amount-1 {
            var randomSides: Int?
            repeat {
                randomSides = range.randomElement()
            } while(randomSides == question.correctAnswer)
            range.remove(at: index)
            alternatives.append(Shape(sides: randomSides!, colorIndex: index))
        }
        alternatives.append(Shape(sides: question.correctAnswer, colorIndex: amount-1))
        alternatives.shuffle()
    }
    
    // MARK: - Struct(s)
    
    struct Shape: Identifiable {
        let sides: Int
        let colorIndex: Int
        var isAQuestion: Bool = false
        var id = UUID()
    }
}

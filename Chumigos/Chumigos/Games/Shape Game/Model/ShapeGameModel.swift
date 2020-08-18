//
//  ShapeGameModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

struct ShapeGameModel {
    
    // MARK: - Variables
    
    // Constant variables
    private var amount: Int = 4
    private let isAscending: Bool = Bool.random()
    
    // Variables
    private(set) var alternatives: [Shape] = []
    private(set) var questions: [Question] = []
    private(set) var round: [Shape] = []
    private var difficulty: Difficulty
    
    // MARK: - Init
    
    init(difficulty: Difficulty = .easy) {
        self.difficulty = difficulty
        generateRound()
        generateQuestions()
        generateAlternatives()
    }
    
    // MARK: - Functions to Generate the Variables
    
    func getDifficulty() -> Difficulty {
        return difficulty
    }
    
    mutating func createGame() {
        self.alternatives = []
        self.questions = []
        self.round = []
        generateRound()
        generateQuestions()
        generateAlternatives()
    }
    
    private mutating func generateRound() {
        
        switch difficulty {
        case .easy:
            let range = isAscending ? 3..<6 : 6..<9
            let initialNumberOfSides = Int.random(in: range)
            for index in 0..<amount {
                let value = isAscending ? index : -index
                round.append(Shape(sides: initialNumberOfSides+value, colorIndex: index))
            }
        case .medium:
            let range = isAscending ? 3..<5 : 9..<11
            let initialNumberOfSides = Int.random(in: range)
            for index in 0..<amount {
                let value = isAscending ? index : -index
                round.append(Shape(sides: initialNumberOfSides+(value*2), colorIndex: index))
            }
        case .hard:
            amount = 6
            let range = 3..<6
            let initialNumberOfSides = Int.random(in: range)
            for index in 0..<amount {
                if (index % 2) == 0 {
                    round.append(Shape(sides: initialNumberOfSides+2, colorIndex: index))
                } else {
                    round.append(Shape(sides: initialNumberOfSides-1, colorIndex: index))
                }
            }
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
    
    mutating func occupyQuestion(with index: Int, alternative: Int) {
        for (index, question) in questions.enumerated() {
            if question.currentAnswer == alternative {
                self.vacateQuestion(with: index)
            }
        }
        self.questions[index].occupy(with: alternative)
    }
    
    mutating func vacateQuestion(with index: Int) {
        self.questions[index].vacate()
    }
    
    func allQuestionsAreCorrect() -> Bool {
        let numberOfQuestions = questions.count
        var numberOfCorrectQuestions = 0
        questions.forEach {
            if $0.isCorrect {
                numberOfCorrectQuestions += 1
            }
        }
        return numberOfQuestions == numberOfCorrectQuestions
    }
    
    func allQuestionsAreOccupied() -> Bool {
        let numberOfQuestions = questions.count
        var numbersOfOccupiedQuestions = 0
        questions.forEach {
            if $0.isOcupied {
                numbersOfOccupiedQuestions += 1
            }
        }
        return numberOfQuestions == numbersOfOccupiedQuestions
    }
    
    // MARK: - Struct(s)
    
    struct Shape: Identifiable {
        
        let sides: Int
        let colorIndex: Int
        var isAQuestion: Bool = false
        var id = UUID()
    }
}

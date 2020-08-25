//
//  ShapeGameModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

struct ShapeGameModel {
    
    // MARK: - Variables
    
    // Constant variables
    private var amount: Int = 4
    private let isAscending: Bool = Bool.random()
    
    // Variables
    private(set) var alternatives: [ShapeGameModel.Alternative] = []
    private(set) var questions: [Question] = []
    private(set) var round: [ShapeGameModel.ShapeForm] = []
    private var difficulty: Difficulty
    private var randomColors: [Color]
    
    // MARK: - Init
    
    init(difficulty: Difficulty = .easy) {
        self.difficulty = difficulty
        randomColors = Color.getRandomColors(amount: amount)
        generateRound()
        generateQuestions()
        generateAlternatives()
    }
    
    // MARK: - Functions to Generate the Variables
    
    func getDifficulty() -> Difficulty {
        return difficulty
    }
    
    func getRandomColor() -> [Color] {
        return randomColors
    }
    
    mutating func createGame() {
        self.randomColors = []
        self.alternatives = []
        self.questions = []
        self.round = []
        self.changeDifficulty()
        generateRound()
        generateQuestions()
        generateAlternatives()
        randomColors = Color.getRandomColors(amount: amount)
    }
    
    private mutating func generateRound() {
        
        switch difficulty {
        case .easy:
            let range = isAscending ? 3..<6 : 6..<9
            let initialNumberOfSides = Int.random(in: range)
            for index in 0..<amount {
                let value = isAscending ? index : -index
                round.append(ShapeForm(sides: initialNumberOfSides+value, colorIndex: index))
            }
        case .medium:
            let range = isAscending ? 3..<5 : 9..<11
            let initialNumberOfSides = Int.random(in: range)
            for index in 0..<amount {
                let value = isAscending ? index : -index
                round.append(ShapeForm(sides: initialNumberOfSides+(value*2), colorIndex: index))
            }
        case .hard:
            amount = 6
            let range = 3..<6
            var initialNumberOfSides = Int.random(in: range)
            for index in 0..<amount {
                if (index % 2) == 0 {
                    round.append(ShapeForm(sides: initialNumberOfSides, colorIndex: index))
                    initialNumberOfSides += 2
                } else {
                    round.append(ShapeForm(sides: initialNumberOfSides, colorIndex: index))
                    initialNumberOfSides -= 1
                }
            }
        }
    }
    
    mutating func changeDifficulty() {
        if self.difficulty == .easy {
            difficulty = .medium
        } else if self.difficulty == .medium {
            difficulty = .hard
        }
    }
    
    mutating func resetUUID() {
        for i in 0..<questions.count {
            questions[i].id = UUID()
        }
        
        for i in 0..<alternatives.count {
            alternatives[i].id = UUID()
        }
        
        for i in 0..<round.count {
            round[i].id = UUID()
        }
    }
    
    private mutating func generateQuestions() {
        
        let questionIndex = round.count-1
        questions.append(Question(correctAnswer: round[questionIndex].sides))
        round[questionIndex].isAQuestion = true
    }
    
    private mutating func generateAlternatives() {
        
        var range = Array(3...11)
        let question = questions.first!
        
        for index in 0..<amount-1 {
            var randomSides: Int?
            repeat {
                randomSides = range.randomElement()
            } while(randomSides == question.correctAnswer || alternatives.compactMap( { $0.value } ).contains(randomSides))
            range.remove(at: index)
            alternatives.append(Alternative(value: randomSides!, colorIndex: index))
        }
        alternatives.append(Alternative(value: question.correctAnswer, colorIndex: amount-1))
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
    
    func findQuestion(with value: Int?) -> Question? {
        let match = questions.first { question in
            question.correctAnswer == value
        }
        return match
    }
    
    struct Alternative: Identifiable {
        let value: Int
        let colorIndex: Int
        var questionValue: Int?
        var id = UUID()
    }
    
    struct ShapeForm: Identifiable {
        
        let sides: Int
        let colorIndex: Int
        var isAQuestion: Bool = false
        var id = UUID()
    }
}

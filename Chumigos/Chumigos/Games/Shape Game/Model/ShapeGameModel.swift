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
    private var questionsColors: [Color] = []
    private var alternativesColors: [Color] = []
    
    // MARK: - Init
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        generateColors()
        generateRound()
        generateQuestions()
        generateAlternatives()
    }
    
    // MARK: - Functions to Generate the Variables
    
    mutating func generateColors() {
        let colorArray = Color.getRandomColors(amount: amount*2)
        let halfSize = colorArray.count / 2
        
        for index in 0..<halfSize {
            questionsColors.append(colorArray[index])
            alternativesColors.append(colorArray[index+4])
        }
    }
    
    func getDifficulty() -> Difficulty {
        return difficulty
    }
    
    func getQuestionsColor() -> [Color] {
        return questionsColors
    }
    
    func getAlternativesColor() -> [Color] {
        return alternativesColors
    }
    
    mutating func createGame() {
        self.questionsColors = []
        self.alternativesColors = []
        self.alternatives = []
        self.questions = []
        self.round = []
       
        generateColors()
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
        for index in 0..<questions.count {
            questions[index].id = UUID()
        }
        
        for index in 0..<alternatives.count {
            alternatives[index].id = UUID()
        }
        
        for index in 0..<round.count {
            round[index].id = UUID()
        }
    }
    
    private mutating func generateQuestions() {
        
        let questionIndex = round.count-1
        questions.append(Question(correctAnswer: round[questionIndex].sides))
        round[questionIndex].isAQuestion = true
    }
    
    private mutating func generateAlternatives() {
        
        var range = Array(3...8)
        let question = questions.first!
        
        for index in 0..<amount-1 {
            var randomSides: Int?
            repeat {
                randomSides = range.randomElement()
            } while(randomSides == question.correctAnswer || alternatives.compactMap({$0.value}).contains(randomSides))
            
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

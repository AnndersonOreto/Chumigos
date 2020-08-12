//
//  Piece.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 11/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

enum Difficulty {
    case easy, medium, hard
}

struct SequenceGameModel<GameContent> {
    private var repetitions: Int {
        difficulty == .easy ? 2 : 3
    }
    private var difficulty: Difficulty = .easy
    private var pattern: [Int] = []
    private var sizeOfPattern: Int = 0
    private(set) var alternatives: [SequenceGameModel.Alternative] = []
    private(set) var questions: [SequenceGameModel.Question] = []
    private(set) var sequence: [SequenceGameModel.SequencePiece] = []
    
    init(difficulty: Difficulty, contentFactory: (Int) -> GameContent) {
        self.difficulty = difficulty
        self.sizeOfPattern = self.generateSizeOfPattern()
        self.pattern = self.generatePattern()
        
        for element in self.generateGenericSequence() {
            let content = contentFactory(element)
            self.sequence.append(SequencePiece(value: element, content: content))
        }
        
        self.generateQuestions()
        self.generateAlternatives()
    }
    
    private func generateSizeOfPattern() -> Int {
        return Int.random(in: 0...1) == 0 ? 3 : 4
    }
    
    private func generateGenericSequence() -> [Int] {
        var array = pattern
        for _ in 1..<repetitions {
            array += pattern
        }
        return array
    }
    
    private func generatePattern() -> [Int] {
        var array: [Int] = []
        for n in 1...sizeOfPattern {
            array.append(n)
        }
        array.shuffle()
        return array
    }
    
    private mutating func generateQuestions() {
        switch difficulty {
        case .easy:
            let random = Int.random(in: sizeOfPattern..<sequence.count)
            questions.append(Question(value: sequence[random].value, correctContent: sequence[random].content))
            sequence[random].isAQuestion = true
            
        case .medium:
            let random1 = Int.random(in: sizeOfPattern..<sequence.count)
            var random2: Int
            repeat {
                random2 = Int.random(in: sizeOfPattern..<sequence.count)
            } while sequence[random1].value == sequence[random2].value
            questions.append(Question(value: sequence[random1].value, correctContent: sequence[random1].content))
            questions.append(Question(value: sequence[random2].value, correctContent: sequence[random2].content))
            sequence[random1].isAQuestion = true
            sequence[random2].isAQuestion = true
            
        case .hard:
            let random1 = Int.random(in: sizeOfPattern..<sequence.count)
            var random2: Int
            var random3: Int
            repeat {
                random2 = Int.random(in: sizeOfPattern..<sequence.count)
                random3 = Int.random(in: sizeOfPattern..<sequence.count)
            } while (sequence[random1].value == sequence[random2].value &&
                sequence[random1].value == sequence[random3].value &&
                sequence[random2].value == sequence[random3].value)
            questions.append(Question(value: sequence[random1].value, correctContent: sequence[random1].content))
            questions.append(Question(value: sequence[random2].value, correctContent: sequence[random2].content))
            questions.append(Question(value: sequence[random3].value, correctContent: sequence[random3].content))
            sequence[random1].isAQuestion = true
            sequence[random2].isAQuestion = true
            sequence[random3].isAQuestion = true
        }
    }

    mutating func generateAlternatives() {
        let shuffledPattern = pattern.shuffled()
        for item in shuffledPattern {
            if let match = sequence.firstIndex(where: { $0.value == item }) {
                self.alternatives.append(Alternative(value: sequence[match].value, content: sequence[match].content))
            }
        }
    }
    
    mutating func occupyQuestion(with index: Int, alternative: Int) {
        for (index, question) in questions.enumerated() {
            if question.occupant == alternative {
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
    
    struct Alternative: Identifiable {
        let value: Int
        let content: GameContent
        var id = UUID()
    }

    struct Question {
        let value: Int
        let correctContent: GameContent
        var occupant: Int = 0
        
        var isOcupied: Bool {
            occupant == 0 ? false : true
        }
        
        var isCorrect: Bool {
            occupant == value
        }
        
        mutating func occupy(with occupant: Int) {
            self.occupant = occupant
        }
        
        mutating func vacate() {
            self.occupant = 0
        }
    }
    
    struct SequencePiece: Identifiable {
        let value: Int
        let content: GameContent
        var isAQuestion: Bool = false
        var id = UUID()
    }
}



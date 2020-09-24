//
//  ShapeGameVM.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class ShapeGameViewModel: ObservableObject {
    
    @Published var model: ShapeGameModel
    var wrongAnswersArray: [(ShapeGameModel, Int)] = []
    var gameState: GameState = GameState.NORMAL
    var gameScore: GameScore = GameScore()
    
    var difficulty: Difficulty
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        model = ShapeGameModel(difficulty: difficulty)
    }
    
    private static func createShapeGame(difficulty: Difficulty) -> ShapeGameModel {
        return ShapeGameModel(difficulty: difficulty)
    }
    
    // MARK: - Access to the Model
    
    var round: [ShapeGameModel.ShapeForm] {
        model.round
    }
    
    var alternatives: [ShapeGameModel.Alternative] {
        model.alternatives
    }
    
    var questions: [Question] {
        model.questions
    }
    
    var difficultyForm: Form {
        model.getDifficulty() == .medium ? .STAR : .POLYGON
    }
    
    var getRandomColors: [Color] {
        model.getRandomColor()
    }
    
    // MARK: - Access to the Model
    
    func allQuestionsAreCorrect() -> Bool {
        return model.allQuestionsAreCorrect()
    }
    
    func allQuestionsAreOccupied() -> Bool {
        return model.allQuestionsAreOccupied()
    }
    
    func findQuestion(with value: Int) -> Question? {
        return model.findQuestion(with: value)
    }
    
    // MARK: - Intent(s): Modifies the Model
    
    func occupyQuestion(with index: Int, alternative: Int) {
        model.occupyQuestion(with: index, alternative: alternative)
    }
    
    func vacateQuestion(with index: Int) {
        model.vacateQuestion(with: index)
    }
    
    func getRecapIndex() -> Int {
        if !wrongAnswersArray.isEmpty && gameState == .RECAP {
            return wrongAnswersArray.first!.1
        }
        return -1
    }
    
    func resetGame(index: Int) {
        
        if gameState == .NORMAL {
            
            // Restart game by creating another instance of SequenceGameModel
            model = ShapeGameViewModel.createShapeGame(difficulty: difficulty)
        } else {
            
            if wrongAnswersArray.isEmpty { return }
            print(wrongAnswersArray.count)
            let questionModel = wrongAnswersArray.first!
            print(wrongAnswersArray.count)
            print(questions)
            model = questionModel.0
            model.resetUUID()
            print(questions)
        }
    }
    
    func removeRecapGame() {
        
        if gameState == .RECAP && !wrongAnswersArray.isEmpty {
            wrongAnswersArray.removeFirst()
        }
    }
    
    func verifyWrongQuestion(index: Int) {
        
        // If some question ain't correct, add it to wrongAnswers list
        if !allQuestionsAreCorrect() {
            
            for index in 0..<questions.count {
                model.vacateQuestion(with: index)
            }
            
            //To limit recap try to only one time
            if gameState ==  .NORMAL {
                wrongAnswersArray.append((model, index))
            }
        }
    }
    
    func restartGame() {
        self.model = ShapeGameViewModel.createShapeGame(difficulty: difficulty)
        self.wrongAnswersArray = []
        self.gameState = .NORMAL
        self.gameScore = GameScore()
    }
    
    func changeGameScore() {
        if self.allQuestionsAreCorrect() {
            if self.gameState == .NORMAL {
                self.gameScore.incrementDefaultScore()
            } else {
                self.gameScore.incrementRecapScore()
            }
        } else {
            self.gameScore.disableStreak()
        }
    }
}

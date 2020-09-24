//
//  SequenceGameViewModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 11/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class SequenceGameViewModel: ObservableObject {
    @Published var model: SequenceGameModel
    let difficulty: Difficulty
    var wrongAnswersArray: [(SequenceGameModel, Int)] = []
    var gameState: GameState = GameState.NORMAL
    var gameScore: GameScore = GameScore()
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty

        let isFruit = Bool.random()
        model = SequenceGameModel(difficulty: difficulty) { (assetIndex) in
            return isFruit ? "fruit-\(assetIndex)" : "shape-\(assetIndex)"
        }
    }
    
    func createSequenceGame(difficulty: Difficulty) -> SequenceGameModel {
        let isFruit = Bool.random()
        return SequenceGameModel(difficulty: difficulty) { (assetIndex) in
            return isFruit ? "fruit-\(assetIndex)" : "shape-\(assetIndex)"
        }
    }
    
    // MARK: - Access to the Model
    
    var sequence: [SequenceGameModel.SequencePiece] {
        model.sequence
    }
    
    var alternatives: [SequenceGameModel.Alternative] {
        model.alternatives
    }
    
    var questions: [Question] {
        model.questions
    }
    
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
            model = self.createSequenceGame(difficulty: difficulty)
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
            if gameState == .NORMAL {
                wrongAnswersArray.append((model, index))
            }
        }
    }
    
    func restartGame() {
        self.model = self.createSequenceGame(difficulty: difficulty)
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

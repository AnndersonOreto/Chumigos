//
//  SequenceGameViewModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 11/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class SequenceGameViewModel {
    private var model = createSequenceGame()
    var wrongAnswersArray: [(SequenceGameModel, Int)] = []
    var gameState: GameState = GameState.NORMAL
    
    private static func createSequenceGame() -> SequenceGameModel {
        let isFruit = Bool.random()
        return SequenceGameModel(difficulty: .medium) { (assetIndex) in
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
            
            // Verify if current question is wrong
            verifyWrongQuestion(index: index)
            
            // Restart game by creating another instance of SequenceGameModel
            model = SequenceGameViewModel.createSequenceGame()
        } else {
            
            verifyWrongQuestion(index: index)
            if wrongAnswersArray.isEmpty { return }
            print(wrongAnswersArray.count)
            let questionModel = wrongAnswersArray.removeFirst()
            print(wrongAnswersArray.count)
            print(questions)
            model = questionModel.0
            print(questions)
        }
    }
    
    func verifyWrongQuestion(index: Int) {
        
        // If some question ain't correct, add it to wrongAnswers list
        if !allQuestionsAreCorrect() {
            
            for i in 0..<questions.count {
                model.vacateQuestion(with: i)
            }
            
            wrongAnswersArray.append((model, index))
        }
    }
}

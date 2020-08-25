//
//  ShapeGameVM.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class ShapeGameViewModel: ObservableObject {
    
    @Published var model = createSequenceGame()
    var wrongAnswersArray: [(ShapeGameModel, Int)] = []
    var gameState: GameState = GameState.NORMAL
    
    private static func createSequenceGame() -> ShapeGameModel {
        return ShapeGameModel(difficulty: .medium)
    }
    
    // MARK: - Access to the Model
    
    var round: [ShapeForm] {
        model.round
    }
    
    var alternatives: [ShapeForm] {
        model.alternatives
    }
    
    var questions: [Question] {
        model.questions
    }
    
    var difficultyForm: Form {
        model.getDifficulty() == .hard ? .STAR : .POLYGON
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
            
            // Verify if current question is wrong
            verifyWrongQuestion(index: index)
            
            // Restart game by creating another instance of SequenceGameModel
            model = ShapeGameViewModel.createSequenceGame()
        } else {
            
            verifyWrongQuestion(index: index)
            if wrongAnswersArray.isEmpty { return }
            print(wrongAnswersArray.count)
            let questionModel = wrongAnswersArray.first!
            print(wrongAnswersArray.count)
            print(questions)
            model = questionModel.0
            //model.resetUUID()
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
            
            for i in 0..<questions.count {
                model.vacateQuestion(with: i)
            }
            
            wrongAnswersArray.append((model, index))
        }
    }
}

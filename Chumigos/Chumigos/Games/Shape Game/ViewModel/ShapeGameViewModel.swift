//
//  ShapeGameVM.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class ShapeGameViewModel: ObservableObject {
    @Published var model = ShapeGameModel()
    
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
    
    func resetGame() {
        model.createGame()
    }
}

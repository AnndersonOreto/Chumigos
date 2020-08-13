//
//  SequenceGameViewModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 11/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class SequenceGameViewModel: ObservableObject {
    @Published private var model = createSequenceGame()
    
    private static func createSequenceGame() -> SequenceGameModel<String> {
        let isFruit = Bool.random()
        return SequenceGameModel<String>(difficulty: .medium) { (assetIndex) in
            return isFruit ? "fruit-\(assetIndex)" : "shape-\(assetIndex)"
        }
    }
    
    // MARK: - Access to the Model
    
    var sequence: [SequenceGameModel<String>.SequencePiece] {
        model.sequence
    }
    
    var alternatives: [SequenceGameModel<String>.Alternative] {
        model.alternatives
    }
    
    var questions: [SequenceGameModel<String>.Question] {
        return model.questions
    }
    
    func allQuestionsAreCorrect() -> Bool {
        return model.allQuestionsAreCorrect()
    }
    
    func allQuestionsAreOccupied() -> Bool {
        return model.allQuestionsAreOccupied()
    }
    
    // MARK: - Intent(s): Modifies the Model
    
    func occupyQuestion(with index: Int, alternative: Int) {
        model.occupyQuestion(with: index, alternative: alternative)
    }
    
    func vacateQuestion(with index: Int) {
        model.vacateQuestion(with: index)
    }
    
    func resetGame() {
        model = SequenceGameViewModel.createSequenceGame()
    }
}

//
//  TotemGameViewModel.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 17/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI

class TotemGameViewModel: ObservableObject {
    
    @Published var model: TotemGameModel = TotemGameModel()
    @Published var selectedUpTopTotem: [String] = []
    
    var difficulty: Difficulty
    var game: GameObject
    var gameScore: GameScore = GameScore()
    var gameState: GameState = .NORMAL
    var wrongAnswers: [(model: TotemGameModel, index: Int)] = []
    
    init(difficulty: Difficulty, game: GameObject) {
        self.difficulty = difficulty
        self.game = game
    }
    
    // MARK: - Access the model
    var totemPieceList: [TotemPiece] {
        model.totemPieceList
    }
    
    var totemAlternativeList: [[String]] {
        model.totemAlternativeList
    }
    
    var correctUpTopTotem: [String] {
        model.correctUpTopTotem
    }
    
    func answerIsCorrect() -> Bool {
        return selectedUpTopTotem == self.correctUpTopTotem
    }
    
    // MARK: - Reset & Restart
    func resetGame() {
        if gameState == .NORMAL {
            model = TotemGameModel()
        } else {
            if wrongAnswers.isEmpty { return }
            if let first = wrongAnswers.first {
                model = first.model
            }
        }
        selectedUpTopTotem = []
    }
    
    func restartGame() {
        model = TotemGameModel()
        gameState = .NORMAL
        gameScore = GameScore()
        selectedUpTopTotem = []
        wrongAnswers = []
    }
    
    // MARK: - Recap function(s)
    func getRecapIndex() -> Int {
        if gameState == .RECAP && !wrongAnswers.isEmpty {
            return wrongAnswers.first!.index
        }
        return -1
    }
    
    func ifWrongAddAnswer(with index: Int) {
        if gameState == .NORMAL && !answerIsCorrect() {
            wrongAnswers.append((model: self.model, index: index))
        }
    }
    
    func removeRecapGame() {
        if gameState == .RECAP && !wrongAnswers.isEmpty {
            wrongAnswers.removeFirst()
        }
    }
    
    // MARK: - Score function(s)
    func changeGameScore() {
        if answerIsCorrect() {
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

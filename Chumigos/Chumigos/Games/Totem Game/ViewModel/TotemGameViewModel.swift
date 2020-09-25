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
    
    let model: TotemGameModel = TotemGameModel()
    
    @Published var totemPieceList: [TotemPiece] = []
    @Published var totemAlternativeList: [[String]] = []
    var correctUpTopTotem: [String] = []
    var gameScore: GameScore = GameScore()
    var gameState: GameState = .NORMAL
    
    init() {
        generateTotem()
        generateAlternatives()
    }
    
    func generateTotem() {
        totemPieceList = model.generateTotem()
    }
    
    func generateAlternatives() {
        let response = model.generateAlternatives(with: totemPieceList)
        totemAlternativeList = response.0
        correctUpTopTotem = response.1
    }
    
    func resetGame() {
        totemPieceList.removeAll()
        totemAlternativeList.removeAll()
        correctUpTopTotem.removeAll()
        generateTotem()
        generateAlternatives()
    }
    
    func getRecapIndex() -> Int {
        return -1
    }
    
    func changeGameScore(isAnswerCorrect: Bool) {
        if isAnswerCorrect {
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

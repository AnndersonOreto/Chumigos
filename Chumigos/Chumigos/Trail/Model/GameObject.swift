//
//  GameObject.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

enum GameType: String, Codable {
    case pattern, algorithm, decomposition, abstraction
}

import Foundation

struct GameObject: Hashable, Codable {
    
    // MARK: - Variables & Constants
    
    //Game Info
    let id: UUID
    let gameType: GameType
    let gameName: String
    #warning("isAvailable é pra ser false. Está true agora pra loja.")
    var isAvailable: Bool = true
    var isCompleted: Bool = false
    
    //Game Progress
    var maxProgress: Float = 100
    var currentProgress: Float = 0
    var percetageCompleted: Float {
        currentProgress / maxProgress
    }
    
    //Game Status
    var alreadyPlayed: Bool {
        currentProgress > 0 ? true : false
    }
    
    // MARK: - Setter(s)
    
    mutating func setAvailable(_ value: Bool) {
        self.isAvailable = value
    }
    
    mutating func changeIsCompleted() {
        if percetageCompleted == 1 {
            self.isCompleted = true
        }
    }
    
    mutating func increaseCurrentProgress(_ value: Float) {
        
        if currentProgress + value >= maxProgress {
            currentProgress = maxProgress
            AppAnalytics.shared.logEvent(of: .finishedGame, parameters: ["gameObject": gameName])
        } else {
            self.currentProgress += value
        }
    }
}

//
//  GameObject.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

enum GameType: Int, Codable {
    case pattern, algorithm, decomposition, abstraction
}

import Foundation

struct GameObject: Hashable, Codable {
    
    // MARK: - Variables & Constants
    
    //Game Info
    let gameType: GameType
    let gameName: String
    var isAvailable = false
    var isCompleted = false
    
    //Game Progress
    let maxProgress: Float = 100
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
}

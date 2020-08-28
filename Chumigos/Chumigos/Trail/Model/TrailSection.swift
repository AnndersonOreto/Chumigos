//
//  TrailSection.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

struct TrailSection: Identifiable {
    
    // MARK: - Variable(s)
    
    var id = UUID()
    private(set) var available: Bool
    private(set) var trail: [[GameObject]]
    var currentLine: Int = 0 {
        didSet {
            self.changeGamesInLineAvailability()
        }
    }
    
    // MARK: - Init
    
    init(available: Bool, trail: [[GameObject]]) {
        self.available = available
        self.trail = trail
        self.changeGamesInLineAvailability()
    }
    
    // MARK: - Setter(s)
    
    mutating func setAvailable(_ newValue: Bool) {
        self.available = newValue
    }
    
    mutating func setTrail(_ newTrail: [[GameObject]]) {
        self.trail = newTrail
    }
    
    // MARK: - Function(s)
    
    mutating func changeGamesInLineAvailability() {
        if self.available && currentLine < trail.count {
            for gameIndex in 0..<trail[currentLine].count {
                trail[currentLine][gameIndex].isAvailable = true
            }
        }
    }
    
    mutating func changeCurrentLine() {
        let gamesAmount = trail[currentLine].count
        var gamesPlayed = 0
        
        for game in trail[currentLine] {
            if game.alreadyPlayed {
                gamesPlayed += 1
            }
        }
        
        if gamesAmount == 3 && gamesPlayed >= 2 {
            self.currentLine += 1
        } else if gamesAmount <= 2 && gamesPlayed >= 1 {
            self.currentLine += 1
        }
    }
}

//
//  TrailSection.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

struct TrailSection: Identifiable, Codable {
    
    // MARK: - Variable(s)
    
    var id = UUID()
    private(set) var available: Bool
    var lines: [[GameObject]]
    var currentLine: Int = 0 {
        didSet {
            self.changeGamesInLineAvailability()
        }
    }
    
    // MARK: - Init(s)
    
    init(id: UUID, lines: [[GameObject]], available: Bool, currentLine: Int) {
        self.id = id
        self.lines = lines
        self.available = available
        self.currentLine = currentLine
    }
    
    init(available: Bool, lines: [[GameObject]]) {
        self.available = available
        self.lines = lines
        self.changeGamesInLineAvailability()
    }
    
    // MARK: - Setter(s)
    
    mutating func setAvailable(_ newValue: Bool) {
        self.available = newValue
    }
    
    // MARK: - Function(s)
    
    mutating func changeGamesInLineAvailability() {
        if self.available && currentLine < lines.count {
            for gameIndex in 0..<lines[currentLine].count {
                lines[currentLine][gameIndex].isAvailable = true
            }
        }
    }
    
    mutating func changeCurrentLine() {
        let gamesAmount = lines[currentLine].count
        var gamesPlayed = 0
        
        for game in lines[currentLine] {
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

//
//  ScoreEnum.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 16/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

class GameScore {
    
    //Constants
    private let standartScore = 10
    private let recapScore = 5
    private let streakScore = 5
    private var currentStreak = 0
    //Variables
    private(set) var currentScore: Int = 0
    private(set) var streak: Bool = false
    
    // MARK: - Functions
    
    /// Increment score for the normal state
    func incrementDefaultScore() {
        
        var incrementValue = 0
        
        //Get the right value for increment
        if streak {
            currentStreak += streakScore
            incrementValue = standartScore + currentStreak
        } else {
            incrementValue = standartScore
        }
        
        self.currentScore += incrementValue
        
        self.activateStreak()
    }
    
    /// Increment score for the recap state
    func incrementRecapScore() {
        //Streak doesnt count in recap
        self.currentScore += recapScore
    }
    
    /// Call this if you want start a streak
    func activateStreak() {
        self.streak = true
    }
    
    /// Call this if you want to break the steak
    func disableStreak() {
        self.streak = false
    }
}

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
    
    //Variables
    private(set) var currentScore: Int = 0
    private(set) var streak: Bool = false
    
    //MARK:- Functions
    
    func incrementDefaultScore() {
        
        let incrementValue = streak ? standartScore + streakScore : standartScore
        self.currentScore += incrementValue
        self.activateStreak()
    }
    
    func incrementRecapScore() {
        //Streak doesnt count in recap
        self.currentScore += recapScore
    }
    
    func activateStreak() {
        self.streak = true
    }
    
    func disableStreak() {
        self.streak = false
    }
}

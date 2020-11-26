//
//  AuthenticationManager.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 14/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import Combine

class AuthenticationProfile {
    
    var id: String
    var email: String?
    var name: String = ""
    var phone: String = ""
    var role: String = ""
    var pending: String = ""
    var lives: Int = 0
    var bonusLives: Int = 0
    var lastErrorDate = ""
    var trail: [TrailSection] = []
    var lifeManager: LifeManager
    
    init(name: String, id: String, email: String?, lives: Int, bonusLife: Int, trail: [TrailSection], lastErrorDate: String) {
        
        self.id = id
        self.email = email
        self.name = name
        self.trail = trail
        self.lives = lives
        self.bonusLives = bonusLife
        self.lastErrorDate = lastErrorDate
        self.lifeManager = LifeManager(userLifes: lives, bonusLives: bonusLife, lastErrorDate: lastErrorDate, userEmail: email ?? "")
    }
    
    func saveGameObject(_ gameObject: GameObject) {
        
        #warning("Muitos for aninhados! Precisamos refatorar.")
        for section in 0..<trail.count {
            for line in 0..<trail[section].lines.count {
                for column in 0..<trail[section].lines[line].count {
                    let game = trail[section].lines[line][column]
                    if game.id == gameObject.id {
                        trail[section].lines[line][column] = gameObject
                    }
                }
            }
        }
    }
}

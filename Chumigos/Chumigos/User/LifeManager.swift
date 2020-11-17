//
//  LifeManager.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 03/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

class LifeManager {
    
    let database: DatabaseManager = DatabaseManager()

    // Maximum lives that user can have as time earned lives
    let MAXLIFES = 5
    
    // Current amount of lives the user has
    var countLife: Int
    
    // Bought lives that are apart from time earned ones
    var countBonusLife: Int
    
    // Sum of bought lives and time earned lives
    var totalLifes: Int {
        return countLife + countBonusLife
    }
    
    var userEmail: String = ""
    
    var lastErrorDate: String
    
    var haveLifeToPlay: Bool {
        if countLife > 0 || countBonusLife > 0 {
            return true
        } else {
            return false
        }
    }
    
    init(userLifes: Int, lastErrorDate: String, userEmail: String) {

        self.lastErrorDate = lastErrorDate
        countLife = userLifes
        countBonusLife = 0
        self.userEmail = userEmail
    }
    
    /// Increment life or bonus life according to isBonus parameter. Default value is setted to false.
    /// - Parameter isBonus: true when increase bonus life
    /// - When isBonus is FALSE call the function like this:
    /// ```
    /// incrementLife()
    /// ```
    /// - When isBonus is TRUE call the function like this:
    /// ```
    /// incrementLife(isBonus: true)
    /// ```
    /// - Note: Default value is setted to false.
    func incrementLife(isBonus: Bool = false) {
        if isBonus {
            self.incrementCountBonusLife()
        } else {
            self.incrementCountLife()
        }
    }
    
    /// Decrease life or bonus life if it is > 0
    func decreaseLife() {
        if countBonusLife > 0 {
            self.decreaseCountBonusLife()
        } else {
            self.decreaseCountLife()
        }
    }
    
    /// Increment life or bonus life according to isBonus parameter. Default value is setted to false.
    /// - When isBonus is FALSE call the function like this:
    /// ```
    /// incrementLife(by: 5)
    /// ```
    /// - When isBonus is TRUE call the function like this:
    /// ```
    /// incrementLife(by: 5, isBonus: true)
    /// ```
    /// - Parameters:
    ///   - value: number to increase
    ///   - isBonus: true when increase bonus life
    func incrementLife(by value: Int, isBonus: Bool = false) {
        if isBonus {
            self.incrementCountBonusLife(by: value)
        } else {
            self.incrementCountLife(by: value)
        }
    }
    
    /// Decrease life value by certain value. When bonus life > 0, it will decrease bonus life.
    /// - Parameter value: number to decrease
    func decreaseLife(by value: Int) {
        if countBonusLife > 0 {
            self.decreaseCountBonusLife(by: value)
        } else {
            self.decreaseCountLife(by: value)
        }
    }
    
    private func updateLives() {
//        database.getUserLifes { (value) in
//            self.countLife = value
//        }
    }
    
    private func calculateCurrentLives() {
        
    }
        
    /// Increment life value by 1
    private func incrementCountLife() {
        countLife += 1
        if countLife > MAXLIFES {
            countLife = MAXLIFES
        }
    }
    
    /// Increment life value by certain value
    /// - Parameter value: number to increment
    private func incrementCountLife(by value: Int) {
        countLife += value
        if countLife > MAXLIFES {
            countLife = MAXLIFES
        }
    }
    
    /// Decrease life value by 1
    private func decreaseCountLife() {
        if countLife == MAXLIFES {
            database.saveLastErrorDate(date: Date(), email: userEmail)
        }
        countLife -= 1
        if countLife < 0 {
            countLife = 0
        }
        
        database.updateUserLifes(newLives: countLife, email: userEmail)
    }

    /// Decrease life value by certain value
    /// - Parameter value: number to decrease
    private func decreaseCountLife(by value: Int) {
        countLife -= value
        if countLife <= 0 {
            countLife = 0
        }
    }
    
    /// Increment bonus life value by 1
    private func incrementCountBonusLife() {
        countBonusLife += 1
        if countBonusLife > MAXLIFES {
            countBonusLife = MAXLIFES
        }
    }
    
    /// Increment bonus life value by certain value
    /// - Parameter value: number to increment
    private func incrementCountBonusLife(by value: Int) {
        countBonusLife += value
        if countBonusLife > MAXLIFES {
            countBonusLife = MAXLIFES
        }
    }
    
    /// Decrease bonus life value by 1
    private func decreaseCountBonusLife() {
        countBonusLife -= 1
        if countBonusLife <= 0 {
            countBonusLife = 0
        }
    }
    
    /// Decrease bonus life value by certain value
    /// - Parameter value: number to decrease
    private func decreaseCountBonusLife(by value: Int) {
        countBonusLife -= value
        if countBonusLife <= 0 {
            countBonusLife = 0
        }
    }
}

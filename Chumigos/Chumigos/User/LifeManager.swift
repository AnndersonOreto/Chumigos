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
        calculateCurrentLives()
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
    func incrementLife(by value: Int = 1, isBonus: Bool = false) {
        if isBonus {
            self.incrementCountBonusLife(by: value)
        } else {
            self.incrementCountLife(by: value)
            database.updateUserLifes(newLives: countLife, email: userEmail)
        }
    }
    
    /// Decrease life value by certain value. When bonus life > 0, it will decrease bonus life.
    /// - Parameter value: number to decrease
    func decreaseLife(by value: Int = 1) {
        if countBonusLife > 0 {
            self.decreaseCountBonusLife(by: value)
        } else {
            self.decreaseCountLife(by: value)
            database.updateUserLifes(newLives: countLife, email: userEmail)
        }
    }
    
    func remainingTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        
        if let date = dateFormatter.date(from: lastErrorDate) {
            let time = date.addingTimeInterval(3600).timeIntervalSinceNow
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            
            return formatter.string(from: time)
        }
        return nil
    }
    
    private func calculateCurrentLives() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        
        if let date = dateFormatter.date(from: lastErrorDate) {
            let difference = Date().timeIntervalSince(date)
            let differenceInHours = Int(difference / 3600)
            
            if differenceInHours > 0 {
                incrementLife(by: differenceInHours)
                lastErrorDate = dateFormatter.string(from: Date())
                database.saveLastErrorDate(date: dateFormatter.date(from: lastErrorDate) ?? Date(), email: userEmail)
            } else if differenceInHours < 0 {
                lastErrorDate = dateFormatter.string(from: Date())
                database.saveLastErrorDate(date: dateFormatter.date(from: lastErrorDate) ?? Date(), email: userEmail)
            }
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

    /// Decrease life value by certain value
    /// - Parameter value: number to decrease
    private func decreaseCountLife(by value: Int) {
        if countLife == MAXLIFES {
            database.saveLastErrorDate(date: Date(), email: userEmail)
        }
        countLife -= value
        if countLife <= 0 {
            countLife = 0
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
    
    /// Decrease bonus life value by certain value
    /// - Parameter value: number to decrease
    private func decreaseCountBonusLife(by value: Int) {
        countBonusLife -= value
        if countBonusLife <= 0 {
            countBonusLife = 0
        }
    }
}

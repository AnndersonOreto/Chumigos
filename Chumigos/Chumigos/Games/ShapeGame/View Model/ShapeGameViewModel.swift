//
//  ShapeGameViewModel.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 24/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

class ShapeGameViewModel: ObservableObject {
    
    // MARK: - Variables
    
    // Published variables
    @Published var roundList: [(formSizes: Int, color: Color)] = []
    @Published var alternativeList: [(formSizes: Int, color: Color)] = []
    
    // Auxiliary variables
    var answer: (formSizes: Int, color: Color) = (0, Color.white)
    private final let AMOUNT: Int = 4
    
    // MARK: - Init
    init () {
        
        // Initializing variables
        self.answer = (0, Color.white)
        self.roundList = []
        self.alternativeList = []
        
        // Setup the game
        setup()
    }
    
    // MARK: - Setup
    
    // Start game setup
    private func setup() {
        
        // Randomize pattern order
        let isAscending = Bool.random()
        
        let formList = generateRound(isAscending: isAscending, amount: AMOUNT)
        
        let colorFormList = Color.getRandomColors(amount: AMOUNT)
        
        for i in 0..<4 {
            self.roundList.append((formList[i], colorFormList[i]))
        }
        
        self.alternativeList = generateAlternatives(amount: AMOUNT)
    }
    
    // MARK: - Auxiliary functions
    
    /// Generate a new round returning the pattern list as a form side list
    /// - Parameters:
    ///   - isAscending: pattern order ascending or descending
    ///   - amount: amount of elements to compose the pattern
    func generateRound(isAscending: Bool, amount: Int) -> [Int] {
        
        // Initial number of sides
        var randomGeometrySeed: Int = 0
        
        if isAscending {
            randomGeometrySeed = Int.random(in: 3..<6)
        } else {
            randomGeometrySeed = Int.random(in: 6..<9)
        }
        
        // Resulting list with the desired pattern
        var formList: [Int] = []
        
        // If ascending or descending order
        if isAscending {
            
            for i in 0..<amount {
                formList.append(randomGeometrySeed+i)
            }
        } else {
            
            for i in 0..<amount {
                formList.append(randomGeometrySeed-i)
            }
        }
        
        return formList
    }
    
    /// Generate alternatives for answers
    /// - Parameter amount: amount of alternatives that will be generated
    func generateAlternatives(amount: Int) -> [(Int, Color)] {
        
        let answer = roundList.randomElement() ?? (0, Color.white)
        var alternatives: [(Int, Color)] = []
        
        // Set answer to global round answer
        self.answer = answer
        
        for _ in 0..<amount-1 {
            
            // Random number to be appended to answers list
            var random: Int = 0
            
            // Repeat until the random number is not the answer
            repeat {
                random = Int.random(in: 3...12)
            } while(random == answer.formSizes)
            
            // Add the random number to the alternatives list
            alternatives.append((random, Color.getRandomColor()))
        }
        
        alternatives.append((answer))
        alternatives.shuffle()
        
        return alternatives
    }
}

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
    
    @Published var roundList: [Int] = []
    @Published var colorList: [Color] = []
    
    init () {
        
        setup()
    }
    
    // Start game setup
    private func setup() {
        
        // Randomize pattern order
        let isAscending = Bool.random()
        
        self.roundList = generateRound(isAscending: isAscending, amount: 4)
        
        self.colorList = Color.getRandomColors(amount: 4)
    }
    
    // Generate a new round returning the pattern list as a form side list
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
}

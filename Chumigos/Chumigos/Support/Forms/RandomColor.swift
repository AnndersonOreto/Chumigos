//
//  RandomColor.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

// Extension used to get app colors
extension Color {
    
    // MARK: - Default colors
    
    // Dark mode headline color
    static let whiteGhost = Color(UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1))
    
    // Dark mode body color
    static let lightGray = Color(UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1))
    
    // Regular gray color
    static let regularGray = Color(UIColor(red: 0.686, green: 0.686, blue: 0.686, alpha: 1))
    
    // Light mode headline color
    static let darkGray = Color(UIColor(red: 0.467, green: 0.467, blue: 0.467, alpha: 1))
    
    // Light mode body color
    static let regularBlack = Color(UIColor(red: 0.294, green: 0.294, blue: 0.294, alpha: 1))
    
    // MARK: - Primary colors
    
    static let darkBlue = Color(UIColor(red: 0.078, green: 0.325, blue: 0.639, alpha: 1))
    
    static let secondaryBlue = Color(UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1))
    
    static let regularBlue = Color(UIColor(red: 0.094, green: 0.6, blue: 0.839, alpha: 1))
    
    static let lightBlue = Color(UIColor(red: 0.11, green: 0.69, blue: 0.965, alpha: 1))
    
    // MARK: - Positive colors
    
    static let darkGreen = Color(UIColor(red: 0.345, green: 0.655, blue: 0, alpha: 1))
    
    static let secondaryGreen = Color(UIColor(red: 0.345, green: 0.8, blue: 0.008, alpha: 1))
    
    static let regularGreen = Color(UIColor(red: 0.678, green: 0.906, blue: 0.337, alpha: 1))
    
    static let lightGreen = Color(UIColor(red: 0.722, green: 0.949, blue: 0.545, alpha: 1))
    
    // MARK: - Progress/warning colors
    
    static let darkOrange = Color(UIColor(red: 1, green: 0.588, blue: 0, alpha: 1))
    
    static let secondaryOrange = Color(UIColor(red: 1, green: 0.694, blue: 0, alpha: 1))
    
    static let regularGold = Color(UIColor(red: 1, green: 0.784, blue: 0, alpha: 1))
    
    static let lightGold = Color(UIColor(red: 1, green: 0.851, blue: 0, alpha: 1))
    
    // MARK: - Negative colors
    
    static let darkRed = Color(UIColor(red: 0.918, green: 0.169, blue: 0.169, alpha: 1))
    
    static let secondaryRed = Color(UIColor(red: 1, green: 0.294, blue: 0.294, alpha: 1))
    
    static let regularRed = Color(UIColor(red: 1, green: 0.471, blue: 0.471, alpha: 1))
    
    static let lightRed = Color(UIColor(red: 0.961, green: 0.643, blue: 0.643, alpha: 1))
    
    // MARK: - Miscelaneous colors
    
    static let darkPurple = Color(UIColor(red: 0.435, green: 0.306, blue: 0.631, alpha: 1))
    
    static let secondaryPurple = Color(UIColor(red: 0.565, green: 0.412, blue: 0.804, alpha: 1))
    
    static let regularPurple = Color(UIColor(red: 0.808, green: 0.51, blue: 1, alpha: 1))
    
    static let lightPurple = Color(UIColor(red: 1, green: 0.667, blue: 0.871, alpha: 1))
    
    // MARK: - Random colors
    
    // Get a single random color
    static let randomColor = [regularGreen, regularGold, regularRed, regularPurple, regularBlue].randomElement()
    
    static func getRandomColors(amount: Int) -> [Color] {
        
        // Valid color list
        var colorList = [regularGreen, regularGold, regularRed, regularPurple, regularBlue]
        
        if amount >= colorList.count {
            
            return colorList
        } else {
            
            var resp: [Color] = []
            
            for _ in 0..<amount {
                
                let randomElement = colorList.randomElement()
                for j in 0..<colorList.count {
                    if colorList[j] == randomElement {
                        colorList.remove(at: j)
                    }
                }
                resp.append(randomElement ?? regularGreen)
            }
            
            return resp
        }
    }
}

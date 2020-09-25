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
    static let Ghost = Color(UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1))
    
    // Dark mode body color
    static let Swan = Color(UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1))
    
    // Regular gray color
    static let Hare = Color(UIColor(red: 0.686, green: 0.686, blue: 0.686, alpha: 1))
    
    // Light mode headline color
    static let Wolf = Color(UIColor(red: 0.467, green: 0.467, blue: 0.467, alpha: 1))
    
    // Light mode body color
    static let Eel = Color(UIColor(red: 0.294, green: 0.294, blue: 0.294, alpha: 1))
    
    // MARK: - Primary colors
    
    static let Narwhal = Color(UIColor(red: 0.078, green: 0.325, blue: 0.639, alpha: 1))
    
    static let Humpback = Color(UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1))
    
    static let Whale = Color(UIColor(red: 0.094, green: 0.6, blue: 0.839, alpha: 1))
    
    static let Macaw = Color(UIColor(red: 0.11, green: 0.69, blue: 0.965, alpha: 1))
    
    // MARK: - Positive colors
    
    static let TreeFrog = Color(UIColor(red: 0.345, green: 0.655, blue: 0, alpha: 1))
    
    static let Owl = Color(UIColor(red: 0.345, green: 0.8, blue: 0.008, alpha: 1))
    
    static let Turtle = Color(UIColor(red: 0.678, green: 0.906, blue: 0.337, alpha: 1))
    
    static let SeaSponge = Color(UIColor(red: 0.722, green: 0.949, blue: 0.545, alpha: 1))
    
    static let Grizzly = Color(UIColor(red: 0.647, green: 0.4, blue: 0.267, alpha: 1))
    
    // MARK: - Progress/warning colors
    
    static let Fox = Color(UIColor(red: 1, green: 0.588, blue: 0, alpha: 1))
    
    static let Lion = Color(UIColor(red: 1, green: 0.694, blue: 0, alpha: 1))
    
    static let Bee = Color(UIColor(red: 1, green: 0.784, blue: 0, alpha: 1))
    
    static let Duck = Color(UIColor(red: 1, green: 0.851, blue: 0, alpha: 1))
    
    // MARK: - Negative colors
    
    static let FireAnt = Color(UIColor(red: 0.918, green: 0.169, blue: 0.169, alpha: 1))
    
    static let Cardinal = Color(UIColor(red: 1, green: 0.294, blue: 0.294, alpha: 1))
    
    static let Crab = Color(UIColor(red: 1, green: 0.471, blue: 0.471, alpha: 1))
    
    static let Pig = Color(UIColor(red: 0.961, green: 0.643, blue: 0.643, alpha: 1))
    
    // MARK: - Miscelaneous colors
    
    static let Butterfly = Color(UIColor(red: 0.435, green: 0.306, blue: 0.631, alpha: 1))
    
    static let Betta = Color(UIColor(red: 0.565, green: 0.412, blue: 0.804, alpha: 1))
    
    static let Beetle = Color(UIColor(red: 0.808, green: 0.51, blue: 1, alpha: 1))
    
    static let Starfish = Color(UIColor(red: 1, green: 0.667, blue: 0.871, alpha: 1))
    
    // MARK: - Random colors
    
    static let colorList: [Color] = [Lion, Crab, Fox, Grizzly, Owl, Macaw, Humpback, Betta, Wolf, Starfish]
    
    // Get single random color
    static func getRandomColor() -> Color {
        return colorList.randomElement() ?? Color.white
    }

    // Get list of random colors
    static func getRandomColors(amount: Int) -> [Color] {
        
        // Valid color list
        var colorList = [Lion, Crab, Fox, Grizzly, Owl, Macaw, Humpback, Betta, Wolf, Starfish]
        
        if amount >= colorList.count {
            return colorList
        } else {
            var resp: [Color] = []
            
            for _ in 0..<amount {
                let randomElement = colorList.randomElement()
                
                for (index, element) in colorList.enumerated() {
                    if element == randomElement {
                        colorList.remove(at: index)
                    }
                }
                for (index, element) in colorList.enumerated() where element == randomElement {
                    print("oi\(index)")
                }
                
                resp.append(randomElement ?? Turtle)
            }
            
            return resp
        }
    }
}

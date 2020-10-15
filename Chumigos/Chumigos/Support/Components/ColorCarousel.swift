//
//  ColorCarousel.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 30/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI

class ColorCarousel {
    
    private var colors: [Color] = [.Macaw, .Turtle, .Pig, .Duck, .Beetle]
    
    func next() {
        
        let firstColor = colors.removeFirst()
        //Adding the first color again in the array
        colors.append(firstColor)
    }
    
    func getFirstColor() -> Color? {
        return colors.first
    }
    
}

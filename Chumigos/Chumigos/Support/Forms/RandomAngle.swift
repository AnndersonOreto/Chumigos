//
//  RandomAngle.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

// Extension used to generate random angles
extension Angle {
    
    // Random element with no range
    static func randomAngle() -> Angle {
        
        let randomDegree = Double.random(in: 0..<360).rounded(.down)
        
        return Angle(degrees: randomDegree)
    }
    
    // Random element with predefined angles
    static func randomDefinedAngle() -> Angle {
        
        let randomDegree = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0].randomElement()
        
        return Angle(degrees: randomDegree ?? 0.0)
    }
}

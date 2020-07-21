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
    
    func randomAngle() -> Angle {
        
        let randomDegree = Double.random(in: 0..<360).rounded(.down)
        
        return Angle.init(degrees: randomDegree)
    }
}

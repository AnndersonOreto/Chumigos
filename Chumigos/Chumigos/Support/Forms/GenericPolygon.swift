//
//  GenericPolygon.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

// Extension used to create custom polygons
extension Path {
    
    // Create custom regular polygons
    static func regularPolygon(sides: Int, in rect: CGRect, inset: CGFloat = 0) -> Path {
        
        let width = rect.size.width - inset * 2
        let height = rect.size.height - inset * 2
        let hypotenuse = Double(min(width, height)) / 2.0
        let centerPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        return Path { path in (0...sides).forEach { index in
            
                let angle = ((Double(index) * (360.0 / Double(sides))) - 90) * Double.pi / 180
                let point = CGPoint(
                    x: centerPoint.x + CGFloat(cos(angle) * hypotenuse),
                    y: centerPoint.y + CGFloat(sin(angle) * hypotenuse)
                )
            
                if index == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.closeSubpath()
        }
        .offsetBy(dx: inset, dy: inset)
    }
}

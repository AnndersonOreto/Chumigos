//
//  FormTriangle.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

/// Custom form to be used with a frame size
/// Shapes also support the same StrokeStyle parameter for creating more advanced strokes
struct Triangle: Shape {
    
    // Function that creates a triangle with given bounded area
    func path(in rect: CGRect) -> Path {
        
        // Custom path to make the triangle
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

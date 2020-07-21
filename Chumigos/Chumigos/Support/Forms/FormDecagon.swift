//
//  FormHeptagon.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

/// Create a Decagon structure
public struct Decagon: InsettableShape {
    
    let inset: CGFloat
    
    public func inset(by amount: CGFloat) -> Decagon {
        Decagon(inset: self.inset + amount)
    }
    
    public func path(in rect: CGRect) -> Path {
        Path.regularPolygon(sides: 10, in: rect, inset: inset)
    }
    
    public init() {
        inset = 0
    }
    
    public init(inset: CGFloat) {
        self.inset = inset
    }
}


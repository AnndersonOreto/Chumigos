//
//  RandomForm.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 22/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

//struct RandomForm {
//    static func getRandomFormList(amount: Int, isAscending: Bool, in rect: CGRect) -> [Path] {
//
//        // Polygon or star shape
//        let isPolygon = Bool.random()
//
//        // Initial number of sides
//        let randomGeometrySeed = Int.random(in: 3..<11)
//
//        // Resulting list with the desired pattern
//        var formList: [Path] = []
//
//        // If ascending or descending order
//        if isAscending {
//
//            if isPolygon {
//            for i in 0..<amount {
//                formList.append(Path.regularPolygon(sides: randomGeometrySeed+i, in: rect))
//            }
//            } else {
//                formList.append(Path.regularStar(corners: randomGeometrySeed+i, smoothness: 0.45, in: rect))
//            }
//        } else {
//
//        }
//    }
//}

// Forms id
public enum Form {
    case POLYGON
    case STAR
}

public struct GenericForm: Shape {
    
    public let form: Form
    public let sides: Int
    
    public func inset() -> GenericForm {
        GenericForm(form: self.form, sides: self.sides)
    }
    
    public func path(in rect: CGRect) -> Path {
        
        switch form {
            
        // Polygon
        case .POLYGON:
            return Path.regularPolygon(sides: sides, in: rect)
            
        // Star
        case .STAR:
            return Path.regularStar(corners: sides, smoothness: 0.45, in: rect)
        }
    }
    
    public init() {
        form = Form.POLYGON
        sides = 3
    }
    
    public init(form: Form, sides: Int) {
        self.form = form
        self.sides = sides
    }
}

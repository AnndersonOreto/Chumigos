//
//  customRoundedCorners.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 09/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomRoundedCorners: ViewModifier {
    
    struct RoundedCorner: Shape {
        var radius: CGFloat
        var corners: UIRectCorner
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    func customRoundedCorners(radius: CGFloat, corners: UIRectCorner) -> some View {
        return self.modifier(CustomRoundedCorners(radius: radius, corners: corners))
    }
}

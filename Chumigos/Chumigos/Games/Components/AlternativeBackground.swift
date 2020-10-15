//
//  AlternativeBackground.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

// Does the same thing that BackgroundAlternative does, but as a ViewModifier
struct AlternativeBackground: ViewModifier {
    let size: CGSize
    
    func body(content: Content) -> some View {
        ZStack {
            content
            //BackgroundStroke
            Rectangle()
                .fill(Color.background)
                .opacity(0.75)
                .frame(width: self.size.width * 1.42, height: self.size.width * 1.42)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .offset(y: 4.5)
                        .stroke(Color.optionBorder, lineWidth: 2)
            )
        }
    }
}

extension View {
    // Function to call the modifier more easily
    func alternativeBackground(size: CGSize) -> some View {
        return modifier(AlternativeBackground(size: size))
    }
}

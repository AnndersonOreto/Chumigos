//
//  DynamicFont.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 03/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct DynamicFont: ViewModifier {
    
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat
    var weight: Font.Weight
    
    func body(content: Content) -> some View {
        let dynamicSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(Font.custom(name, size: dynamicSize).weight(weight))
    }
}

extension View {
    func dynamicFont(name: String, size: CGFloat, weight: Font.Weight) -> some View {
        return self.modifier(DynamicFont(name: name, size: size, weight: weight))
    }
}

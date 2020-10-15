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
        
        let customFont = Font.custom(name, size: dynamicSize).weight(weight)
        
        return content.font(customFont)
    }
}

extension View {
    func dynamicFont(name: String = "Rubik", size: CGFloat, weight: Font.Weight) -> some View {
        return self.modifier(DynamicFont(name: name, size: size, weight: weight))
    }
}

extension Text {
    
    func defaultText() -> some View {
        self.tracking(1)
    }
    
}

struct CustomText: View {
    
    let string: String
    
    init(_ string: String) {
        self.string = string
    }
    
    var body: some View {
        Text(string)
        .tracking(1)
    }
}

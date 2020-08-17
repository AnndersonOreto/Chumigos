//
//  GameButton.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 04/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

struct GameButtonStyle: ButtonStyle {
    
    var buttonColor: Color
    var pressedButtonColor: Color
    var buttonBackgroundColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        ZStack {
            
            // Background rectangle used to give a 3D style
            Rectangle()
                .frame(width: 191, height: 45+16)
                .offset(x: 0, y: 32)
                .background(Color.clear)
                .foregroundColor(buttonBackgroundColor)
                .cornerRadius(12)
                
            configuration.label
            .frame(width: 191, height: 45)
                .background(configuration.isPressed ? pressedButtonColor : buttonColor)
            .cornerRadius(12)
                .offset(y: configuration.isPressed ? 8 : 0)
                .font(.custom("Rubik-Bold", size: 20.0))
                .foregroundColor(Color.Ghost)
        }
    }
}


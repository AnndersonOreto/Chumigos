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
    var isButtonEnable: Bool
    var textColor: Color?
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        ZStack {
            
            // Background rectangle used to give a 3D style
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.15, height: (UIScreen.main.bounds.width * 0.035) + (UIScreen.main.bounds.width * 0.013))
                .offset(x: 0, y: UIScreen.main.bounds.width * 0.026)
                .background(Color.clear)
                .foregroundColor(!isButtonEnable ? Color.Hare : buttonBackgroundColor)
                .cornerRadius(12)
            
            if !isButtonEnable {
                configuration.label
                    .frame(width: UIScreen.main.bounds.width * 0.15, height: (UIScreen.main.bounds.width * 0.035))
                    .background(Color.Swan)
                    .cornerRadius(12)
                    .foregroundColor(Color.Hare)
            } else {
                configuration.label
                    .frame(width: UIScreen.main.bounds.width * 0.15, height: (UIScreen.main.bounds.width * 0.035))
                    .background(configuration.isPressed ? pressedButtonColor : buttonColor)
                    .cornerRadius(12)
                    .offset(y: configuration.isPressed ? (UIScreen.main.bounds.width * 0.013)/2 : 0)
                    .foregroundColor(textColor == nil ? Color.Ghost : textColor)
            }
        }.padding(.bottom, 10)
    }
}

//
//  GameButton.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 04/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

struct GameButton: View {
    
    // MARK: - Variables
    
    @State var isPressed: Bool = false
    var buttonLabel: String
    var buttonSize: CGSize
    var buttonColor: Color
    var buttonBackgroundColor: Color
    
    // MARK: - Init
    
    /// Standard button init
    /// - Parameter buttonLabel: label used as button text
    public init(buttonLabel: String) {
        self.buttonSize = CGSize(width: 191, height: 45)
        self.buttonColor = Color.Whale
        self.buttonBackgroundColor = Color.Narwhal
        self.buttonLabel = buttonLabel
    }
    
    /// Custom button init
    /// - Parameters:
    ///   - buttonLabel: label used as button text
    ///   - buttonSize: size of button
    ///   - buttonColor: button color
    ///   - buttonBackgroundColor: button background color
    public init(buttonLabel: String, buttonSize: CGSize, buttonColor: Color, buttonBackgroundColor: Color) {
        self.buttonSize = buttonSize
        self.buttonColor = buttonColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonLabel = buttonLabel
    }
    
    // MARK: - Button structure
    
    var body: some View {
        
        // Main stack
        ZStack {
            
            // Background rectangle used to give a 3D style
            Rectangle()
                .frame(width: buttonSize.width, height: buttonSize.height+16)
                .offset(x: 0, y: 32)
                .background(Color.clear)
                .foregroundColor(buttonBackgroundColor)
                .cornerRadius(12)
            
            // Button used to take action when clicked
            Button(action: {
                
            }) {
                
                // Button label
                Text(buttonLabel)
                    .foregroundColor(Color.Ghost)
                    .font(.custom("Rubik-Bold", size: 20.0))
            }
            .frame(width: buttonSize.width, height: buttonSize.height)
            .background(buttonColor)
            .cornerRadius(12)
            .overlay(GameTouchHandler(didBeginTouch: {
                self.isPressed.toggle()
            }, didEndTouch: {
                self.isPressed.toggle()
            }))
                .offset(y: self.isPressed ? 8 : 0)
        }
    }
}

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

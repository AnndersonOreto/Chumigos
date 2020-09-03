//
//  GameFeedbackMessage.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

enum FeedBackType {
    case WRONG, CORRECT
}

struct GameFeedbackMessage: View {
    var feedbackType: FeedBackType
    
    let screenWidth = UIScreen.main.bounds.width
    
    private let fontName = "Rubik"
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 42).fill(Color.Humpback).frame(width: screenWidth + 10, height: screenWidth * 0.14)
                
                if feedbackType == .CORRECT {
                    Text("Muito bem!")
                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                        .foregroundColor(Color.Ghost)
                        .padding(.top, 20)
                }
                else {
                    Text("ERRRRROOOOOOO!")
                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                        .foregroundColor(Color.Ghost)
                        .padding(.top, 20)
                }
        }
    }
}

//struct GameFeedbackMessage_Previews: PreviewProvider {
//    static var previews: some View {
//        GameFeedbackMessage(feedbackType: .CORRECT)
//    }
//}

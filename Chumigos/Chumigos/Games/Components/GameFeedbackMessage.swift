//
//  GameFeedbackMessage.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

enum FeedBackText {
    case WRONG, CORRECT, NONE
}

struct GameFeedbackMessage: View {
    var feedbackType: FeedBackText
    
    let screenWidth = UIScreen.main.bounds.width
    
    private let fontName = "Rubik"
    var body: some View {
        ZStack(alignment: .top) {
            
            Rectangle()
                .fill(Color.feedbackShape)
                .customRoundedCorners(radius: 42, corners: [.topLeft,  .topRight])
                .frame(width: screenWidth, height: screenWidth * 0.14)
                
                if feedbackType == .CORRECT {
                    Text("Muito bem!")
                        .dynamicFont(name: fontName, size: 20, weight: .bold)
                        .foregroundColor(Color.Ghost)
                        .padding(.top, 20)
                } else if feedbackType == .WRONG {
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

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
    
    private let fontName = "Rubik"
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 42).fill(Color.Humpback).frame(width: UIScreen.main.bounds.width, height: 165)
                
                if feedbackType == .CORRECT {
                    Text("Muito bem!")
                        .font(.custom("Rubik Bold", size: 20))
                        .foregroundColor(Color.Ghost)
                        .padding(.top, 20)
                }
                else {
                    Text("ERRRRROOOOOOO!")
                        .font(.custom("Rubik Bold", size: 20))
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

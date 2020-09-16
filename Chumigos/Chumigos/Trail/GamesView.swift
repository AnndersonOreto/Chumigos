//
//  GamesView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 01/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

// This view chooses which game will show
struct GamesView: View {
    var gameName: String
    
    var body: some View {
        showGame()
    }
}

extension GamesView {
    // Decides which game to show based on the game's name
    func showGame() -> AnyView {
        switch gameName {
        case GameNames.sequenceGameName:
            return AnyView(SequenceGameView())
        case GameNames.shapeGameName:
            return AnyView(ShapeGameView())
        default:
            return AnyView(EmptyView())
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView(gameName: GameNames.sequenceGameName)
    }
}

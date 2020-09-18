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
    
    var game: GameObject
    
    var body: some View {
        showGame()
    }
}

extension GamesView {
    // Decides which game to show based on the game's name
    func showGame() -> AnyView {
        switch game.gameName {
        case GameNames.sequenceGameName1:
            return AnyView(SequenceGameView(gameDifficulty: .easy, game: self.game))
        case GameNames.shapeGameName1:
            return AnyView(ShapeGameView(gameDifficulty: .easy, game: self.game))
        case GameNames.sequenceGameName2:
            return AnyView(SequenceGameView(gameDifficulty: .medium, game: self.game))
        case GameNames.shapeGameName2:
            return AnyView(ShapeGameView(gameDifficulty: .medium, game: self.game))
        default:
            return AnyView(EmptyView())
        }
    }
}

//struct GamesView_Previews: PreviewProvider {
//    static var previews: some View {
//        GamesView(gameName: GameNames.sequenceGameName1)
//    }
//}

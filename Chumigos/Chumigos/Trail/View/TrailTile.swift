//
//  TrailTile.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct TrailTile: View {
    
    let game: GameObject
    
    var body: some View {
        
        VStack() {
            //96x101
            makeTile()
            
            //TODO: PROGRESS BAR
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.Swan)
                .frame(width: 96, height: 10)
                .padding(.top, 10)
            
            Text(game.gameName)
                .foregroundColor(.Eel)
                .font(.custom("Rubik", size: 16)).fontWeight(.medium)
        }
    }
}

extension TrailTile {
    
    func makeTile() -> some View {
        
        var bottomColor: Color = Color.Bee
        var topColor: Color = Color.Bee
        var image: String = "icon-"
        
        if game.isAvailable {
            switch game.gameType {
            case .abstraction:
                bottomColor = .Butterfly
                topColor = .Betta
                image += "abstraction"
            case .algorithm:
                bottomColor = .Narwhal
                topColor = .Humpback
                image += "algorithm"
            case .decomposition:
                bottomColor = .TreeFrog
                topColor = .Owl
                image += "decomposition"
            case .pattern:
                bottomColor = .Cardinal
                topColor = .Crab
                image += "patterns"
            }
        } else {
            bottomColor = .Hare
            topColor = .Swan
            image += "unavailable"
        }
        
        // TODO: adjust size according to screen size
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(bottomColor)
                .frame(width: 96, height: 96)
                .offset(y: 9)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(topColor)
                .frame(width: 96, height: 96)
            
            Image(image)
        }
    }
}

struct TrailTile_Previews: PreviewProvider {
    static var previews: some View {
        TrailTile(game: GameObject(gameType: .abstraction, gameName: ""))
    }
}

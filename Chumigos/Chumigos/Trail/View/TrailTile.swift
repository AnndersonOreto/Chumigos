//
//  TrailTile.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct TrailTile: View {
    
    // MARK: - Contant(s)
    
    let game: GameObject
    let screenWidth = UIScreen.main.bounds.width
    let widthScale: CGFloat = 0.09
    
    // MARK: - View
    
    var body: some View {
        
        VStack() {
            
            makeTile()
            
            progressBar()
            
            Text(game.gameName)
                .foregroundColor(.Eel)
                .font(.custom("Rubik", size: 16)).fontWeight(.medium)
        }
    }
}

// MARK: - Progress Bar

extension TrailTile {
    
    func progressBar() -> some View {
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.Swan)
                .frame(width: screenWidth * widthScale, height: 10)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.Duck)
                .frame(width: (screenWidth * widthScale) * CGFloat(game.percetageCompleted), height: 10)
            
        }.padding(.top, 10)
    }
}

// MARK: - Tile

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
        
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(bottomColor)
                .frame(width: screenWidth * widthScale, height: screenWidth * widthScale)
                .offset(y: screenWidth * 0.0066)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(topColor)
                .frame(width: screenWidth * widthScale, height: screenWidth * widthScale)

            
            Image(image)
                .resizable()
                .frame(width: screenWidth * 0.06, height: screenWidth * 0.06)
        }
    }
}

// MARK: - Preview(s)

struct TrailTile_Previews: PreviewProvider {
    static var previews: some View {
        TrailTile(game: GameObject(gameType: .abstraction, gameName: ""))
    }
}

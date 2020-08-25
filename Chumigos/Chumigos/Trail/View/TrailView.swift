//
//  TrailView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct TrailView: View {
    
    @State private var sections: [TrailSection] = TrailView.mockSections()
    
    static func mockSections() -> [TrailSection] {
        let linha1 = [GameObject(gameType: .pattern, gameName: GameNames.sequenceGameName)]

        let linha2 = [GameObject(gameType: .pattern, gameName: GameNames.shapeGameName), GameObject(gameType: .abstraction, gameName: "Abstraction")]

        let linha3 = [GameObject(gameType: .algorithm, gameName: "Algorithm"), GameObject(gameType: .decomposition, gameName: "Decomposition"), GameObject(gameType: .abstraction, gameName: "Abstraction")]

        let matrix = [linha1, linha2, linha3, linha2]

        return [TrailSection(available: true, trail: matrix), TrailSection(available: false, trail: matrix)]
    }
    
    var body: some View {
        
        VStack {
            
            Button(action: {
                self.sections[0].currentLine += 1
            }) {
                Text("Next Line")
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(self.sections) { (section) in
                    VStack(spacing: 55) {
                        ForEach(section.trail, id: \.self) { line in
                            HStack(spacing: 85) {
                                ForEach(line, id: \.self) { game in
                                    TrailTile(game: game)
                                }
                            }
                        }
                    }
                }
            }
        }.padding(.vertical)

        
    }
}

struct TrailView_Previews: PreviewProvider {
    static var previews: some View {
        TrailView()
    }
}

//
//  TrailView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct TrailView: View {
    
    // MARK: - Variable(s) & Contant(s)
    
    @State private var sections: [TrailSection] = TrailView.mockSections()
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - Static(s)
    
    // Just for test
    static func mockSections() -> [TrailSection] {
        let linha1 = [GameObject(gameType: .pattern, gameName: GameNames.sequenceGameName)]

        let linha2 = [GameObject(gameType: .pattern, gameName: GameNames.shapeGameName), GameObject(gameType: .abstraction, gameName: "Abstraction")]

        let linha3 = [GameObject(gameType: .algorithm, gameName: "Algorithm"), GameObject(gameType: .decomposition, gameName: "Decomposition"), GameObject(gameType: .abstraction, gameName: "Abstraction")]

        let matrix = [linha1, linha2, linha3, linha2]

        return [TrailSection(available: true, trail: matrix), TrailSection(available: false, trail: matrix)]
    }
    
    //MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    
                    // Button just for test
                    Button(action: {
                        self.sections[0].currentLine += 1
                    }) {
                        Text("Next Line")
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.sections) { (section) in
                            VStack(spacing: self.screenWidth * 0.035) {
                                ForEach(section.trail, id: \.self) { line in
                                    HStack(spacing: self.screenWidth * 0.06) {
                                        Spacer()
                                        ForEach(line, id: \.self) { game in
                                            NavigationLink(destination: GamesView(gameName: game.gameName)) {
                                                TrailTile(game: game)
                                            }.buttonStyle(PlainButtonStyle())
                                        }
                                        Spacer()
                                    }
                                }
                            }.padding(.bottom, self.screenWidth * 0.04)
                            .background(section.available ? Color.background : Color.sectionUnavailable)
                        }
                    }
                }.padding(.vertical)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview(s)

struct TrailView_Previews: PreviewProvider {
    static var previews: some View {
        TrailView()
    }
}

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
    
    let screenWidth = UIScreen.main.bounds.width
    
    @Binding var isTabBarActive: Bool
    @State var allowNavigation: Bool = false
    @State var chosenGame: GameObject = GameObject(id: UUID(), gameType: .abstraction, gameName: ".")
    @State private var matrixList: [TrailSection] = CoreDataService.shared.mockSections()
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("", destination: GamesView(game: chosenGame), isActive: $allowNavigation)
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.matrixList) { (section) in
                            VStack(spacing: self.screenWidth * 0.04) {
                                ForEach(section.trail, id: \.self) { line in
                                    HStack(spacing: self.screenWidth * 0.06) {
                                        Spacer()
                                        ForEach(line, id: \.self) { game in
                                            TrailTile(game: game)
                                                .onTapGesture {
                                                    if User.shared.lifeManager.haveLifeToPlay {
                                                        self.chosenGame = game
                                                        self.allowNavigation = true
                                                        self.isTabBarActive = false
                                                    } else {
                                                        self.allowNavigation = false
                                                        // aparecer view da vida
                                                    }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }.padding(.bottom, self.screenWidth * 0.04)
                                .background(section.available ? Color.background : Color.sectionUnavailable)
                        }
                        .onAppear {
                            self.isTabBarActive = true
                            self.matrixList = CoreDataService.shared.retrieveMatrixTrail()
                        }
                    }
                }.padding(.vertical)
                VStack {
                    HStack {
                        Spacer()
                        LifeComponent()
                    }
                    Spacer()
                }.padding()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

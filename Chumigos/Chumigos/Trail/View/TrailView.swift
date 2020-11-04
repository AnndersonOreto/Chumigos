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
    @State var showLifeBanner = false
    
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
                                                        self.showLifeBanner = true
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
                    .blur(radius: self.showLifeBanner ? 27 : 0)
                
                if showLifeBanner {
                    VStack {
                        LifeBanner(showLifeBanner: self.$showLifeBanner)
                            .edgesIgnoringSafeArea(.top)
                        Spacer()
                    }.onAppear {
                        self.isTabBarActive = false
                    }
                    .onDisappear {
                        self.isTabBarActive = true
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        LifeComponent(showLifeBanner: self.$showLifeBanner)
                    }
                    Spacer()
                }.padding()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

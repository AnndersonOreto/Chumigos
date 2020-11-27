//
//  TrailView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct TrailView: View {
    
    // MARK: - Variable(s) & Contant(s)
    
    let screenWidth = UIScreen.main.bounds.width
    let database = DatabaseManager()
    
    @Binding var currentTab: TabItem
    @Binding var isTabBarActive: Bool
    @State var allowNavigation: Bool = false
    @State var chosenGame: GameObject = GameObject(id: UUID(), gameType: .abstraction, gameName: ".")
    @State private var matrixList: [TrailSection] = CoreDataService.shared.mockSections()
    @State var showLifeBanner = false
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            NavigationLink("", destination: GamesView(game: chosenGame), isActive: $allowNavigation)
            Color.background.edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.matrixList) { (section) in
                        VStack(spacing: self.screenWidth * 0.04) {
                            ForEach(section.lines, id: \.self) { line in
                                HStack(spacing: self.screenWidth * 0.06) {
                                    Spacer()
                                    ForEach(line, id: \.self) { game in
                                        TrailTile(game: game)
                                            .onTapGesture {
                                                if let haveLifeToPlay = self.environmentManager.profile?.lifeManager.haveLifeToPlay, haveLifeToPlay {
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
                        self.matrixList = self.environmentManager.profile?.trail ?? []
                        
                    }
                }
            }.padding(.vertical)
            .blur(radius: self.showLifeBanner ? 27 : 0)
            
            if showLifeBanner {
                VStack {
                    LifeBanner(showLifeBanner: self.$showLifeBanner, tab: $currentTab)
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
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            SoundManager.shared.playMusic(gameMusic: .trail)
            SoundManager.shared.currentMusicVolume = 0.5
        }
    }
}

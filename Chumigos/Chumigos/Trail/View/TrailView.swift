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
    
    @Binding var isTabBarActive: Bool
    @State private var matrixList: [TrailSection] = CoreDataService.shared.mockSections()
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.matrixList) { (section) in
                            VStack(spacing: self.screenWidth * 0.04) {
                                ForEach(section.lines, id: \.self) { line in
                                    HStack(spacing: self.screenWidth * 0.06) {
                                        Spacer()
                                        ForEach(line, id: \.self) { game in
                                            NavigationLink(destination: GamesView(game: game)) {
                                                TrailTile(game: game)
                                            }.buttonStyle(PlainButtonStyle())
                                                .simultaneousGesture(TapGesture().onEnded {
                                                    self.isTabBarActive = false
                                                })
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
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

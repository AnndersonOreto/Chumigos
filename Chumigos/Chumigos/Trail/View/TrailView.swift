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
    
    @ObservedObject var viewModel: TrailViewModel = TrailViewModel()
    let screenWidth = UIScreen.main.bounds.width
    
    @Binding var isTabBarActive: Bool
    
    @State var matrixList: [TrailSection] = CoreDataService.shared.mockSections()
    
    //MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    
                    // Button just for test
                    Button(action: {
                        self.matrixList[0].currentLine += 1
                    }) {
                        Text("Next Line")
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.matrixList) { (section) in
                            VStack(spacing: self.screenWidth * 0.04) {
                                ForEach(section.trail, id: \.self) { line in
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
                    }
                }.padding(.vertical)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear {
                self.isTabBarActive = true
                self.matrixList = CoreDataService.shared.retrieveMatrixTrail()
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

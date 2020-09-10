//
//  MainView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 02/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

enum TabItem {
    case profile, trail, achievements, shop
}

struct MainView: View {
    
    private var screenWidth = UIScreen.main.bounds.width
    @State private var currentTab: TabItem = .trail
    @State private var showPopUp = false
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            Group {
                showView()
                tabBar()
            }
        }
    }
}

extension MainView {
    
    private func tabBar() -> some View {
        HStack{
            ZStack {
                Rectangle()
                    .fill(Color.Hare)
                    .frame(width: screenWidth * 0.079)
                Rectangle()
                    .fill(Color.white)
                    .frame(width: screenWidth * 0.077)
                
                VStack(spacing: screenWidth * 0.03){
                    
                    //Profile
                    Button(action: {
                        self.currentTab = .profile
                    }) {
                        Image("Avatar 2")
                        .resizable()
                        .frame(width: screenWidth * 0.047, height: screenWidth * 0.047)
                    }
                    
                    //Trail
                    Button(action: {
                        
                        self.currentTab = .trail
                    }) {
                        Rectangle()
                        .frame(width: screenWidth * 0.033, height: screenWidth * 0.033)
                    }
                    
                    //Achievements
                    Button(action: {
                        
                        self.currentTab = .achievements
                    }) {
                        Rectangle()
                        .frame(width: screenWidth * 0.033, height: screenWidth * 0.033)
                    }
                    
                    //Shop
                    Button(action: {
                        
                        self.currentTab = .shop
                    }) {
                        Rectangle()
                        .frame(width: screenWidth * 0.033, height: screenWidth * 0.033)
                    }
                    
                    Spacer()
                    
                    //Logout
                    Button(action: {
                        //TODO: Logout action
                    }) {
                        Rectangle()
                        .frame(width: screenWidth * 0.033, height: screenWidth * 0.033)
                    }
                    
                }.padding(.vertical)
            }.edgesIgnoringSafeArea([.bottom, .horizontal]).buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
}

extension MainView {
    
    private func showView() -> AnyView {
        
        switch currentTab {
        case .profile:
            //Mostrar perfil
            return AnyView(ConfigurationView())
        case .trail:
            return AnyView(TrailView())
        case .achievements:
            //coroa
            return AnyView(EmptyView())
        case .shop:
            //as bolinhas
            return AnyView(EmptyView())
        }
        
//        return EmptyView()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//
//  ContentView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 14/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI
import SpriteKit
import CoreData

struct ContentView: View {
    
    @ObservedObject var viewModel = HomeScreenViewModel()
    
    @State private var showAvatarSelection = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SequenceGameView()) {
                    Text("Jogo da Sequencia")
                }
                
                NavigationLink(destination: ShapeGameView()) {
                    Text("Jogo da Forma")
                }
                
                Button(action: {
                    self.showAvatarSelection.toggle()
                }) {
                    Text("Show Detail")
                }.sheet(isPresented: $showAvatarSelection) {
                    withAnimation {
                        AvatarSelectionView(closeModalAction: {
                            self.showAvatarSelection = false
                        })
                    }
                }
                
                
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
         
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.locale, .init(identifier: "en"))
    }
}

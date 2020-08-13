//
//  ContentView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 14/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @ObservedObject var viewModel = HomeScreenViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SequenceView()) {
                    Text("Jogo da Sequencia")
                }
                
                NavigationLink(destination: ShapeGameView()) {
                    Text("Jogo da Forma")
                }
                
                NavigationLink(destination: StudyingView()) {
                    Text("Studying SwiftUI 1")
                }
                
                NavigationLink(destination: ShapeGameNewView()) {
                    Text("Studying SwiftUI 2")
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

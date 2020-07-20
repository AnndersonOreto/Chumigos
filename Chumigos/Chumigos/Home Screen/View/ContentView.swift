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
    
    var scene: SKScene {
        let scene = SequenceGameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SequenceGameView()) {
                    Text("Jogo da Sequencia")
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

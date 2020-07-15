//
//  ContentView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 14/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = HomeScreenViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.getHelloWorld())
            Button(action: {
                self.viewModel.setHelloWorld(newName: "aaa")
            }) {
                Text("aaa")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

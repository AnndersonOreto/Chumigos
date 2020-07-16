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
                
                Functions().generateSequence(num_of_patterns: 2, sizes: [3,2], repetition: 2)
                
            }) {
                Text("Hello World!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.locale, .init(identifier: "fr"))
    }
}

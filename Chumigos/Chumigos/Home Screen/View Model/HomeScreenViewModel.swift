//
//  HomeScreenViewModel.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 15/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

class HomeScreenViewModel: ObservableObject {
    
    @Published private var hello = "Hello World!"
    
    func getHelloWorld() -> String {
        return hello
    }
    
    func setHelloWorld(newName: String) {
        hello = newName
    }
    
}

//
//  GameEnvironment.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 29/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CoreGraphics

class GameEnvironment: ObservableObject {
    
    func verifyObject<T: GameViewModelProtocol>(viewModel: T) -> Bool {
        return viewModel.verify()
    }
}

protocol GameViewModelProtocol {
    
    var answers: [(answer: Int, rect: CGRect, rectID: Int)] { get set }
    
    func verify() -> Bool
}

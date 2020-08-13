//
//  ShapeGameVM.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class ShapeGameVM: ObservableObject {
    @Published var model = ShapeGameModel()
    let randomColors = Color.getRandomColors(amount: 8)
    
    // MARK: - Access to the Model
    
    var round: [ShapeGameModel.Shape] {
        model.round
    }
    
    var alternatives: [ShapeGameModel.Shape] {
        model.alternatives
    }
    
    var questions: [Question] {
        model.questions
    }
}

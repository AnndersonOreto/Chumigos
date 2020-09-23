//
//  TotemGameViewModel.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 17/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI

class TotemGameViewModel: ObservableObject {
    
    let model: TotemGameModel = TotemGameModel()
    
    @Published var totemPieceList: [TotemPiece] = []
    
    init() {
        generateTotem()
    }
    
    func generateTotem() {
        totemPieceList = model.generateTotem()
    }
    
    func allQuestionsAreCorrect() -> Bool {
        
        return true
    }
    
    func allQuestionsAreOccupied() -> Bool {
        
        return false
    }
}

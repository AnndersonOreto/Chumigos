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
    
    init() {
        
    }
    
    func allQuestionsAreCorrect() -> Bool {
        
        return true
    }
    
    func allQuestionsAreOccupied() -> Bool {
        
        return false
    }
}

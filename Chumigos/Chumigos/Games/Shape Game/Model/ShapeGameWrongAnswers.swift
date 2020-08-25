//
//  ShapeGameWrongAnswers.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 20/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

struct ShapeGameWrongAnswer {
    
    private(set) var wrongAlternatives: [ShapeGameModel.Alternative] = []
    private(set) var wrongPattern: [ShapeGameModel.ShapeForm] = []
    private(set) var progressBarIndex: Int = 0
    
    init(_ wrongAlternatives: [ShapeGameModel.Alternative], _ wrongPattern: [ShapeGameModel.ShapeForm], _ progressBarIndex: Int) {
        self.wrongAlternatives = wrongAlternatives
        self.wrongPattern = wrongPattern
        self.progressBarIndex = progressBarIndex
    }
}

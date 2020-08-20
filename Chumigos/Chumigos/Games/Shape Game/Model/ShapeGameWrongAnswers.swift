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
    
    private(set) var wrongAlternatives: [ShapeForm] = []
    private(set) var wrongPattern: [ShapeForm] = []
    private(set) var progressBarIndex: Int = 0
    
    init(_ wrongAlternatives: [ShapeForm], _ wrongPattern: [ShapeForm], _ progressBarIndex: Int) {
        self.wrongAlternatives = wrongAlternatives
        self.wrongPattern = wrongPattern
        self.progressBarIndex = progressBarIndex
    }
}

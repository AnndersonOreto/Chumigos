//
//  Question.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

struct Question {
    let correctAnswer: Int
    var currentAnswer: Int?
    
    var isOcupied: Bool {
        currentAnswer == nil ? false : true
    }
    
    var isCorrect: Bool {
        currentAnswer == correctAnswer
    }
    
    mutating func occupy(with answer: Int) {
        self.currentAnswer = answer
    }
    
    mutating func vacate() {
        self.currentAnswer = nil
    }
}

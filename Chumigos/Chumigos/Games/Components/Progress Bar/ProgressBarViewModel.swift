
//
//  ProgressBarViewModel.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 05/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

/// Progress bar used in games to indicate how is the using performing
class ProgressBarViewModel: ObservableObject {
    
    // MARK: - Variables
    
    @Published var progressStatusList: [Color] = []
    @Published var currentQuestion: Int = 0
    
    init(questionAmount: Int) {
        
        progressStatusList = [Color](repeating: Color.Swan, count: questionAmount)
    }
    
    func incrementQuestion() {
        self.currentQuestion += 1
    }
    
    func isLastQuestion() -> Bool {
        return currentQuestion >= progressStatusList.count
    }
    
    func checkAnswer(isCorrect: Bool) {
        
        // Increment current question index
        incrementQuestion()
        
        // Prevent array out bounds access
        if isLastQuestion() { return }
        
        // Mark current question as green if it is right
        if isCorrect {
            self.progressStatusList[currentQuestion-1] = Color.TreeFrog
            return
        }
        self.progressStatusList[currentQuestion-1] = Color.FireAnt
    }
}

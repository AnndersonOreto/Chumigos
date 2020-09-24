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
    private let questionAmount: Int
    
    init(questionAmount: Int) {
        
        progressStatusList = [Color](repeating: Color.progressBar, count: questionAmount)
        self.questionAmount = questionAmount
    }
    
    func incrementQuestion() {
        self.currentQuestion += 1
    }
    
    func isLastQuestion() -> Bool {
        return currentQuestion >= progressStatusList.count-1
    }
    
    func checkAnswer(isCorrect: Bool, nextIndex: Int) {
        
        // Mark current question as green if it is right
        if isCorrect {
            self.progressStatusList[currentQuestion] = Color.TreeFrog
        } else {
            self.progressStatusList[currentQuestion] = Color.FireAnt
        }
        
        if nextIndex == -1 && isLastQuestion() { return }
        
        if nextIndex == -1 {
            // Increment current question index
            incrementQuestion()
        } else {
            currentQuestion = nextIndex
        }
    }
    
    func restartProgressBar() {
        self.progressStatusList = [Color](repeating: Color.Swan, count: questionAmount)
        self.currentQuestion = 0
    }
}

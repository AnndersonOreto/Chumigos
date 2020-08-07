
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
    
    init() {
        progressStatusList = [Color.regularGreen, Color.swanColor, Color.swanColor, Color.swanColor, Color.swanColor]
    }
    
    func incrementQuestion() {
        self.currentQuestion += 1
    }
    
    func isLastQuestion() -> Bool {
        return currentQuestion >= progressStatusList.count
    }
    
    func checkAndswer(isCorrect: Bool) {
        
        if isCorrect {
            self.progressStatusList[currentQuestion] = Color.regularGreen
            return
        }
        self.progressStatusList[currentQuestion] = Color.regularRed
    }
}

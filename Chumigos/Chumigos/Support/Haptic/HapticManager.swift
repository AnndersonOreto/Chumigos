//
//  HapticManager.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 02/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CoreHaptics
import SwiftUI

class HapticManager: ObservableObject {
    
    // MARK: - Init
    let generator = UINotificationFeedbackGenerator()

    
    init() {
        
    }
    
    // MARK: - Simple Haptic Functions
    public func hapticFeedback(type: FeedBackHaptic) {
        if UserDefaults.standard.bool(forKey: "loggio_vibration") {
            switch type {
            case .SUCESS:
                simpleSuccess()
            case .ERROR:
                simpleError()
            case .WARNING:
                simpleWarning()
            }
        }
    }
    
    /// Vibration corresponding to success
    private func simpleSuccess() {
        
        // Trigger feedback
        generator.notificationOccurred(.success)
    }
    
    /// Vibration corresponding to warning
    private func simpleWarning() {
        
        // Trigger feedback
        generator.notificationOccurred(.warning)
    }
    
    /// Vibration corresponding to error
    private func simpleError() {
        
        // Trigger feedback
        generator.notificationOccurred(.error)
    }
}


enum FeedBackHaptic {
    case SUCESS, WARNING, ERROR
}

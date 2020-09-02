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
    
    init() {
        
    }
    
    // MARK: - Simple Haptic Functions
    
    private func prepareSimpleHaptic() -> UINotificationFeedbackGenerator {
        
        let generator = UINotificationFeedbackGenerator()
        return generator
    }
    
    /// Vibration corresponding to success
    public func simpleSuccess() {
        
        // Trigger feedback
        prepareSimpleHaptic().notificationOccurred(.success)
    }
    
    /// Vibration corresponding to warning
    public func simpleWarning() {
        
        // Trigger feedback
        prepareSimpleHaptic().notificationOccurred(.warning)
    }
    
    /// Vibration corresponding to error
    public func simpleError() {
        
        // Trigger feedback
        prepareSimpleHaptic().notificationOccurred(.error)
    }
}

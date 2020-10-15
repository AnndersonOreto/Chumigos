//
//  ConfigurationViewModel.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 03/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

class ConfigurationViewModel: ObservableObject {
    
    init() {
        
    }
    
    func toggleNotificationValue(value: Bool) {
        UserDefaults.standard.set(value, forKey: "loggio_notification")
        return
    }
    
    func toggleVibrationValue(value: Bool) {
        UserDefaults.standard.set(value, forKey: "loggio_vibration")
    }
    
    func toggleDarkModeValue(value: Bool) {
        SceneDelegate.shared?.window!.overrideUserInterfaceStyle = value ? .dark : .light
    }
    
    func togglePreferencesModeValue() {
    }
    
}

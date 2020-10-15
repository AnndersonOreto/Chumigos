//
//  AppAnalytics.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 15/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import FirebaseAnalytics

public enum AnalyticEventType: String {
    case appLaunch = "loggio_launch"
    case appClose = "loggio_close"
}

class AppAnalytics {
    
    // MARK: - Singleton instance
    
    static var shared: AppAnalytics = {
        let instance = AppAnalytics()
        
        return instance
    }()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    /// Generates a log event to analytics dashboard
    /// - Parameter type: Event type
    public func logEvent(of type: AnalyticEventType) {
        
        Analytics.logEvent(type.rawValue, parameters: [
            AnalyticsParameterItemID: "id-\(type.rawValue)",
            AnalyticsParameterItemName: type.rawValue,
            AnalyticsParameterContentType: "cont"
        ])
    }
    
    /// Generates a log event to analytics dashboard
    /// - Parameter type: Event type as a String
    public func logEvent(of type: String) {
        
        Analytics.logEvent(type, parameters: [
            AnalyticsParameterItemID: "id-\(type)",
            AnalyticsParameterItemName: type,
            AnalyticsParameterContentType: "cont"
        ])
    }
}


//
//  AppAnalytics.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 14/10/20.
//  Created by Guilherme Piccoli on 15/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import FirebaseAnalytics

// MARK: - Event Type
public enum AnalyticEventType: String {
    case appLaunch = "loggio_launch"
    case appClose = "loggio_close"
    case gameScore = "game_score"
    case launchGame = "launch_game"
    case launchAvatarScreen = "launch_avatar_screen"
    case gameRecap = "game_recap"
    case finishedGame = "finished_game"
}

class AppAnalytics {
    
    // MARK: - Singleton instance
    static let shared = AppAnalytics()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    /// Generates a log event to analytics dashboard
    /// - Parameter type: Event type
    public func logEvent(of type: AnalyticEventType) {
        Analytics.logEvent(type.rawValue, parameters: [
            "id": "id-\(type.rawValue)",
            "name": type.rawValue
            //AnalyticsParameterContentType: "cont"
        ])
    }
    
    /// Generates a log event to analytics dashboard
    /// - Parameters type: [String:Any] -> Example [AnalyticsParameterValue: value]
    public func logEvent(of type: AnalyticEventType, parameters: [String: Any]) {
        Analytics.logEvent(type.rawValue, parameters: parameters)
    }
    
    /// Generates a log event to analytics dashboard
    /// - Parameters type: Event type,  Int
    public func logEvent(of type: AnalyticEventType, with value: Int) {
        Analytics.logEvent(type.rawValue, parameters: [
            "id": "id-\(type.rawValue)",
            "item-name": type.rawValue,
            //"AnalyticsParameterContentType: "cont",
            "value": value
        ])
    }
    
    /// Generates a log event to analytics dashboard
    /// - Parameters type: Event type,  Bool
    public func logEvent(of type: AnalyticEventType, with value: Bool) {
        Analytics.logEvent(type.rawValue, parameters: [
            "id": "id-\(type.rawValue)",
            "item-name": type.rawValue,
            //AnalyticsParameterContentType: "cont",
            "value": value
        ])
    }
    
    /// Generates a log event to analytics dashboard
    /// - Parameter type: Event type as a String
    public func logEvent(of type: String) {
        Analytics.logEvent(type, parameters: [
            "id": "id-\(type)",
            "item-name": type
            //AnalyticsParameterContentType: "cont"
        ])
    }
}

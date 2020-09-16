//
//  NotificationManager.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 02/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    
    // MARK: - Constants
    
    
    final let DAY_IN_SECONDS: Double = 86400
    
    // MARK: - Int
    
    init() {
        
    }
    
    // MARK: - Functions
    
    /// Send a daily notification
    public func dailyNotification(title: String?, body: String?) {
        
        if UserDefaults.standard.bool(forKey: "loggio_notification") {
            if !updateNextNotification() { return }
            
            // Create a notification and set its message
            let notification = UNMutableNotificationContent()
            notification.title = title ?? "It is time for practice"
            notification.body = body ?? "Hop in to learn more and have lots of fun"
            
            // Create a date from now that adds the amount of seconds ahead on time
            let date = Date().addingTimeInterval(DAY_IN_SECONDS)
            
            // Set components that will be used to count time
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            
            // Trigger notification
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Generate a UUID for the identifier on NotificationRequest
            let uuidString = UUID().uuidString
            
            // Create a notification request to be added in the Notification Center scheduler
            let request = UNNotificationRequest(identifier: uuidString, content: notification, trigger: trigger)
            
            // Instantiate the Notification Center
            let center = UNUserNotificationCenter.current()
            
            center.add(request, withCompletionHandler: { (error) in
                
                if error != nil {
                    print("Could not send push notification")
                }
            })
            
            UserDefaults.standard.setValue(date, forKey: "loggio_last_notification")
        }
    }
    
    private func updateNextNotification() -> Bool {
        
        let date = UserDefaults.standard.value(forKey: "loggio_last_notification")
        
        if date != nil {
            
            guard let lastDate = date as? Date else { return true }
            
            if lastDate <= Date() {
                return true
            }
            
            return false
        }
        
        return true
    }
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func registerForPushNotifications() {
        UserDefaults.standard.set(true, forKey: "loggio_vibration")
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
}

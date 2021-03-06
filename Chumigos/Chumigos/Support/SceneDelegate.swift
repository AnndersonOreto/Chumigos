//
//  SceneDelegate.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 14/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private(set) static var shared: SceneDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        Self.shared = self
        // Get the managed object context from the shared persistent container.
        let context = CoreDataService.shared.persistentContainer.viewContext
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        
        let contentView = MainView().environment(\.managedObjectContext, context)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let style = UserDefaults.standard.integer(forKey: "loggio_viewStyle")
//            if style == nil {
//                UserDefaults.standard.setValue(0, forKey: "loggio_viewStyle")
//            }
            if style != 0 {
                window.overrideUserInterfaceStyle = (UIUserInterfaceStyle(rawValue: style)!)
            }
            
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                UserDefaults.standard.set(false, forKey: "loggio_notification")
            } else if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                UserDefaults.standard.set(false, forKey: "loggio_notification")
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                UserDefaults.standard.set(true, forKey: "loggio_notification")
            }
        })
        
        let notification = NotificationManager()
        
        if UserDefaults.standard.bool(forKey: "loggio_notification") {
        
            notification.dailyNotification(title: nil, body: nil)
        }

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

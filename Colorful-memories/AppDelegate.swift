//
//  AppDelegate.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 29/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Firebase
import PixelEngine
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaults.standard.object(forKey: "credets") == nil {
            UserDefaults.standard.set(3, forKey: "credets")
        }
        IAPManager.shared.startObserving()
        DispatchQueue.global().async {
            ColorCubeStorage.loadToDefault()
        }
        FirebaseApp.configure()

        #if DEBUG
            UserDefaults.standard.set(50, forKey: "credets")
            print("App for debug")
        #else
            print("App Store build")
        #endif
        notifications(with: application)
        RemoteConfigManager.instance.fetchCloudValues()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_: UIApplication) {
        IAPManager.shared.stopObserving()
    }

    func notifications(with application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
}

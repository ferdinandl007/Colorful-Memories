//
//  RemoteConfigManager.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 30/04/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import FirebaseRemoteConfig
import Foundation
import UIKit

class RemoteConfigManager {
    static let instance = RemoteConfigManager()
    private var remoteConfig: RemoteConfig!

    enum keys: String {
        case colourAPI
        case prossTime
        case render_factor
    }

    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        loadDefaultValues()
    }

    private func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            keys.colourAPI.rawValue: "https://colourize.cf/images/predict",
            keys.prossTime.rawValue: "0.6",
            keys.render_factor.rawValue: 35,
        ]
        remoteConfig.setDefaults(appDefaults as? [String: NSObject])
    }

    func fetchCloudValues() {
        let expirationDuration = 3600

        // [START fetch_config_with_callback]
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate(completionHandler: nil)
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }

    func getColourizeAPI() -> String {
        return remoteConfig[keys.colourAPI.rawValue].stringValue ?? "https://colourize.cf/images/predict"
    }

    func getProcessingTime() -> Double {
        let timeStr = remoteConfig[keys.prossTime.rawValue].stringValue ?? "0.6"
        return Double(timeStr) ?? 0.6
    }

    func getRenderFactor() -> Int {
        let timeStr = remoteConfig[keys.prossTime.rawValue].stringValue ?? "35"
        return Int(timeStr) ?? 35
    }
}

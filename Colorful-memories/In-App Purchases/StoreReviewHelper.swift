//
//  StoreReviewHelper.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 21/04/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Foundation
import StoreKit

enum AppStoreReviewManager {
    static let minimumReviewWorthyActionCount = 2

    static func requestReviewIfAppropriate() {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main

        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        actionCount += 1
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)

        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }

        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)

        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }

        SKStoreReviewController.requestReview()

        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}

extension UserDefaults {
    enum Key: String {
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
    }

    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }

    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }

    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }

    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}

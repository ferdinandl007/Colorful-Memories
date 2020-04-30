//
//  Logging.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 01/05/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Firebase
import Foundation

class Logging {
    static func imageProcessed() {
        Analytics.logEvent("Image processed", parameters: nil)
    }

    static func inAppPurchaseMade(purchase: String) {
        Analytics.logEvent(AnalyticsEventCheckoutProgress, parameters: [AnalyticsParameterItemName: purchase])
    }

    static func inAppPurchaseCancelled() {
        Analytics.logEvent("Purchase cancelled", parameters: nil)
    }

    static func processingError(error: String) {
        Analytics.logEvent("processingError", parameters: ["error": error])
    }

    static func usesOutOfCredit() {
        Analytics.logEvent("usesOutOfCredit", parameters: nil)
    }

    static func logCredit(credit: Int) {
        Analytics.logEvent("Credit", parameters: ["Credit": "\(credit)"])
    }

    static func scanPhoto() {
        Analytics.logEvent("ScanPhoto", parameters: nil)
    }

    static func library() {
        Analytics.logEvent("Library", parameters: nil)
    }
}

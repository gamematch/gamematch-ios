//
//  DeviceInfo.swift
//  GameMatch
//
//  Created by Luke Shi on 10/16/21.
//

import Foundation
import UIKit

class DeviceInfo: NSObject, Codable
{
    let deviceId: String?
    let userId: String?
    let token: String?
    let appPackageId: String?
    let appVersion: String?
    let channelType: String?
    let make: String?
    let model: String?
    let modelVersion: String?
    let notificationOn: Bool?
    let platform: String?
    let platformVersion: String?
    let timezone: String?
    let badgeNumber: Int?

    init(token: String)
    {
        self.token = token

        deviceId = nil
        userId = nil
        badgeNumber = nil

        appPackageId = Bundle.main.bundleIdentifier
        appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        make = "Apple"
        model = "iPhone"
        modelVersion = UIDevice.current.model
        platform = "iOS"
        platformVersion = UIDevice.current.systemVersion
        timezone = TimeZone.current.identifier

#if DEBUG
        channelType = "APNS_SANDBOX"
#else
        channelType = "APNS"
#endif

        notificationOn = true
    }
}

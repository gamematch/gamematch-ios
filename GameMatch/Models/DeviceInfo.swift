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
    let badgeNumber: Int?
    let channelType: String?
    let make: String?
    let model: String?
    let modelVersion: String?
    let notificationOn: Bool?
    let platform: String?
    let platformVersion: String?
    let timezone: String?
    
    init(token: String)
    {
        self.token = token
        
        deviceId = nil
        userId = nil
        badgeNumber = nil
        
#if DEBUG
        channelType = "APNS_SANDBOX"
#else
        channelType = "APNS_PRODUCTION"
#endif
        
        appPackageId = Bundle.main.bundleIdentifier
        make = "Apple"
        model = "iPhone"
        modelVersion = UIDevice.current.model
        platform = "iOS"
        platformVersion = UIDevice.current.systemVersion
        timezone = TimeZone.current.identifier
        
        notificationOn = true
    }
}

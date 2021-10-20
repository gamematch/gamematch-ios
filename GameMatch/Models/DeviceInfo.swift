//
//  DeviceInfo.swift
//  GameMatch
//
//  Created by Luke Shi on 10/16/21.
//

import Foundation

class DeviceInfo: NSObject, Codable
{
    let deviceId: String
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
}

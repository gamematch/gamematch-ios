//
//  PushNotificationManager.swift
//  GameMatch
//
//  Created by Luke Shi on 10/16/21.
//

import UIKit
import UserNotifications

class PushNotificationManager
{
    static let shared = PushNotificationManager()
    
    private let deviceIdKey = "deviceId"
    
    var deviceId: String?
    {
        UserDefaults.standard.string(forKey: deviceIdKey)
    }
    
    var deviceToken: String?
    {
        didSet {
            if let deviceToken = deviceToken {
                print("======= register \(deviceToken) =========")

                if let deviceId = UserDefaults.standard.string(forKey: deviceIdKey) {
                    updateDevice(deviceId: deviceId, deviceToken: deviceToken)
                } else {
                    registerDevice(deviceToken: deviceToken)
                }
            }
        }
    }
    
    private func registerDevice(deviceToken: String)
    {
        DeviceAPIService().register(deviceToken: deviceToken) { [weak self] result in
            switch result {
            case .success(let deviceInfo):
                UserDefaults.standard.set(deviceInfo.deviceId, forKey: self?.deviceIdKey ?? "")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateDevice(deviceId: String, deviceToken: String)
    {
        DeviceAPIService().update(deviceId: deviceId,
                                  deviceToken: deviceToken) { result in
            switch result {
            case .success(()):
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
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
}

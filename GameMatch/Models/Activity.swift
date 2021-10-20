//
//  Activity.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation

class Activity: NSObject, Codable
{
    let id: String
    let sportId: Int?
    let name: String?
    let location: Location?
    let startTime: TimeInterval?
    let endTime: TimeInterval?
    let createdTime: TimeInterval?
    let activityType: String?

    var eventStartTime: Date? {
        if let startTime = startTime {
            return Date(timeIntervalSince1970: startTime)
        }
        return nil
    }
    
    var eventEndTime: Date? {
        if let endTime = endTime {
            return Date(timeIntervalSince1970: endTime)
        }
        return nil
    }
}

class Activities: NSObject, Codable
{
    let activities: [Activity]
}

class Location: NSObject, Codable
{
    let name: String
    let latitude: Double
    let longitude: Double
    let address: String
}

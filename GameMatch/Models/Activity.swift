//
//  Activity.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation

class Activity: NSObject, Codable
{
    let id: Int
    let activity_type: String
    let sport_id: Int
    let latitude: Double
    let longitude: Double
    let address: String
    let numberOfPlayers: Int
    let activityStartTime: TimeInterval
    let activityEndTime: TimeInterval
    let notes: String
    let activityUrl: String
    
    var startTime: Date {
        Date(timeIntervalSince1970: activityStartTime)
    }
    
    var endTime: Date {
        Date(timeIntervalSince1970: activityEndTime)
    }
}

class Activities: NSObject, Codable
{
    let activities: [Activity]
}

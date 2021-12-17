//
//  Activity.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation

class Activity: NSObject, Codable
{
    var id: String?
    var sportId: Int?
    var name: String?
    var location: Location?
    var startTime: Int?
    var endTime: Int?
    var createdTime: Int?
    var activityType: String?
    var invitationUrl: String?
    let cancelled: Bool?
    var isEditable: Bool?

    var eventStartTime: Date? {
        if let startTime = startTime {
            return Date(timeIntervalSince1970: TimeInterval(startTime))
        }
        return nil
    }
    
    var eventEndTime: Date? {
        if let endTime = endTime {
            return Date(timeIntervalSince1970: TimeInterval(endTime))
        }
        return nil
    }
    
    init(name: String, location: Location, startTime: Int, endTime: Int?)
    {
        self.id = nil
        self.name = name
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.createdTime = Int(Date().timeIntervalSince1970)
        self.sportId = 1
        self.activityType = "public"
        self.invitationUrl = nil
        self.cancelled = nil
        
        super.init()
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
    
    init(name: String, latitude: Double, longitude: Double, address: String)
    {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        
        super.init()
    }
}

//
//  CreateActivityViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/19/21.
//

import Foundation
import CoreLocation

class CreateActivityViewModel
{
    func createActivity(latitude: CLLocationDegrees,
                        longitude: CLLocationDegrees,
                        name: String,
                        address: String,
                        completion: @escaping (Result<Activity, Error>) -> Void)
    {
        let location = Location(name: address,
                                latitude: latitude,
                                longitude: longitude,
                                address: address)
        
        let now = Date()
        let activity = Activity(name: name,
                                location: location,
                                startTime: Int(now.addingTimeInterval(24 * 3600).timeIntervalSince1970),
                                endTime: Int(now.addingTimeInterval(26 * 3600).timeIntervalSince1970))
        
        ActivityAPIService().activity(activity,
                                      completion: completion)
    }
}

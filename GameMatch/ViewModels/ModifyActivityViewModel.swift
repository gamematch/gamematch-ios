//
//  CreateActivityViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/19/21.
//

import Foundation
import CoreLocation

class ModifyActivityViewModel
{
    var activity: Activity?

    init(activity: Activity? = nil)
    {
        self.activity = activity
    }

    func modifyActivity(name: String,
                        locationName: String,
                        latitude: CLLocationDegrees,
                        longitude: CLLocationDegrees,
                        address: String?,
                        completion: @escaping (Result<Activity, Error>) -> Void)
    {
        let location = Location(name: locationName,
                                latitude: latitude,
                                longitude: longitude,
                                address: address ?? "")

        let now = Date()
        let startTime = Int(now.addingTimeInterval(24 * 3600).timeIntervalSince1970)
        let endTime = Int(now.addingTimeInterval(26 * 3600).timeIntervalSince1970)

        if let activity = activity {
            activity.name = name
            activity.location = location
            activity.startTime = startTime
            activity.endTime = endTime

            ActivityAPIService().changeActivity(activity,
                                                completion: { (result: Result<Void, Error>) in
                                                    switch result {
                                                    case .success:
                                                        completion(.success((activity)))
                                                    case .failure(let error):
                                                        completion(.failure(error))
                                                    }
                                                })
        } else {
            let activity = Activity(name: name,
                                    location: location,
                                    startTime: startTime,
                                    endTime: endTime)
        
            ActivityAPIService().createActivity(activity,
                                                completion: completion)
        }
    }

    func deleteActivity(completion: @escaping (Result<Void, Error>) -> Void)
    {
        if let activity = activity {
            ActivityAPIService().deleteActivity(activity,
                                                completion: completion)
        }
    }
}

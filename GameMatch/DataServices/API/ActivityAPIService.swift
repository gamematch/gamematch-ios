//
//  ActivityAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation
import CoreLocation

class ActivityAPIService: BaseAPIService
{
    func activities(latitude: CLLocationDegrees,
                    longitude: CLLocationDegrees,
                    name: String?,
                    completion: @escaping (Result<[Activity], Error>) -> Void)
    {
        let locationInfo = ["latitude": latitude,
                            "longitude": longitude]
        var parameters: [String: Any] = ["location": locationInfo]

        if let name = name, !name.isEmpty {
            parameters["sport"] = ["name": name]
        }
        post(request: APIRequests.activities,
             parameters: parameters,
             completion: { (result: Result<Activities, Error>) in
                            switch result {
                            case .success(let activities):
                                completion(.success(activities.activities))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                         })
    }
    
    func activity(latitude: CLLocationDegrees,
                  longitude: CLLocationDegrees,
                  name: String,
                  completion: @escaping (Result<Activity, Error>) -> Void)
    {
        let locationInfo: [String: Any] = ["latitude": latitude,
                                           "longitude": longitude,
                                           "name": name,
                                           "address": "San Ramon, CA 94582"]
        var parameters: [String: Any] = ["location": locationInfo]
        parameters["startTime"] = 1634130150060
        parameters["endTime"] = 1634151355924
        parameters["createdTime"] = 1634018779000
        parameters["activityType"] = "public"
        parameters["sportId"] = 4
        parameters["name"] = "Volleyball Pickup Game Weekly"
        
        post(request: APIRequests.activity,
             parameters: parameters,
             completion: { (result: Result<Activity, Error>) in
                            switch result {
                            case .success(let activity):
                                completion(.success(activity))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                         })
    }
}

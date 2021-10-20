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
    
    func activity(_ activity: Activity,
                  completion: @escaping (Result<Activity, Error>) -> Void)
    {        
        post(request: APIRequests.activity,
             parameters: activity.dict,
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

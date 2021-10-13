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
                    completion: @escaping (Result<[Activity], Error>) -> Void)
    {
        post(request: APIRequests.activities,
             parameters: ["latitude": latitude,
                          "longitude": longitude],
             completion: { (result: Result<Activities, Error>) in
                            switch result {
                            case .success(let activities):
                                completion(.success(activities.activities))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                         })
    }
}

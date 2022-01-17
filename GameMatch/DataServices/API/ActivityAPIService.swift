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
    func getActivities(latitude: CLLocationDegrees,
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

    func getMyActivities(completion: @escaping (Result<[Activity], Error>) -> Void)
    {
        get(request: APIRequests.myActivities,
            completion: { (result: Result<Activities, Error>) in
                            switch result {
                            case .success(let activities):
                                completion(.success(activities.activities))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
    }
    
    func createActivity(_ activity: Activity,
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
    
    func getActivity(id: String,
                     completion: @escaping (Result<Activity, Error>) -> Void)
    {
        get(request: APIRequests.activityDetail,
            pathParam: id,
            completion: { (result: Result<Activity, Error>) in
                            switch result {
                            case .success(let activity):
                                completion(.success(activity))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                         })
    }

    func changeActivity(_ activity: Activity,
                        completion: @escaping (Result<Void, Error>) -> Void)
    {
        patch(request: APIRequests.activity,
              pathParam: activity.id,
              parameters: activity.dict,
              completion: completion)
    }

    func deleteActivity(_ activity: Activity,
                        completion: @escaping (Result<Void, Error>) -> Void)
    {
        delete(request: APIRequests.activity,
               pathParam: activity.id,
               completion: completion)
    }
}

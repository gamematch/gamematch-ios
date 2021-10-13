//
//  ExploreViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation
import CoreLocation

class ExploreViewModel
{
    var activities: [Activity]?
    
    func activities(latitude: CLLocationDegrees,
                    longitude: CLLocationDegrees,
                    name: String,
                    completion: @escaping (Result<Void, Error>) -> Void)
    {
        ActivityAPIService().activities(latitude: latitude,
                                        longitude: longitude,
                                        name: name,
                                        completion: { [weak self] result in
                                            switch result {
                                            case .success(let activities):
                                                self?.activities = activities
                                                completion(.success(()))
                                            case .failure(let error):
                                                completion(.failure(error))
                                            }
                                        })
    }
}

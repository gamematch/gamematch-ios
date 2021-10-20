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
                        completion: @escaping (Result<Activity, Error>) -> Void)
    {
        ActivityAPIService().activity(latitude: latitude,
                                      longitude: longitude,
                                      name: name,
                                      completion: completion)
    }
}

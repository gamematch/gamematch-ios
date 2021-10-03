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
    func activities(latitude: CLLocationDegrees,
                    longitude: CLLocationDegrees,
                    completion: @escaping (Result<[Activity], Error>) -> Void)
    {
        ActivityAPIService().activities(latitude: latitude,
                                        longitude: longitude,
                                        completion: completion)
    }
}

//
//  ExploreViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation
import CoreLocation

class ExploreViewModel: BaseViewModel
{    
    func getActivities(latitude: CLLocationDegrees,
                       longitude: CLLocationDegrees,
                       name: String?)
    {
        loading = true
        ActivityAPIService().getActivities(latitude: latitude,
                                           longitude: longitude,
                                           name: name,
                                           completion: { [weak self] result in
                                                self?.loading = false
                                                switch result {
                                                case .success(let activities):
                                                    self?.data = activities
                                                case .failure(let error):
                                                    self?.error = error
                                                }
                                           })
    }
}

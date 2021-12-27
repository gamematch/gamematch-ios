//
//  ActivitiesViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 12/11/21.
//

import Foundation

class ActivitiesViewModel: BaseViewModel
{
    var activities: [Activity]?

    func getMyActivities(completion: @escaping (Result<Void, Error>) -> Void)
    {
        ActivityAPIService().getMyActivities(completion: { [weak self] result in
                                                switch result {
                                                case .success(let activities):
                                                    if activities.isEmpty == false {
                                                        self?.needData = false
                                                    }

                                                    self?.activities = activities.map { activity in
                                                        activity.isEditable = true
                                                        return activity
                                                    }
                                                    completion(.success(()))
                                                case .failure(let error):
                                                    completion(.failure(error))
                                                }
                                            })
    }
}

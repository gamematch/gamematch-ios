//
//  ActivityDetailsViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/23/21.
//

import Foundation

class ActivityDetailsViewModel
{
    var activity: Activity?
    
    private var activityId: String
    
    init(activityId: String)
    {
        self.activityId = activityId
    }
    
    func getActivity(completion: @escaping (Result<Void, Error>) -> Void)
    {
        ActivityAPIService().getActivity(id: activityId) { [weak self] result in
             switch result {
             case .success(let activity):
                 self?.activity = activity
                 completion(.success(()))
             case .failure(let error):
                 completion(.failure(error))
             }
        }
    }
}

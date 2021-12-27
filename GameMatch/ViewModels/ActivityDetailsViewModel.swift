//
//  ActivityDetailsViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/23/21.
//

import Foundation

class ActivityDetailsViewModel: BaseViewModel
{
    @Published var activity: Activity?
    
    private var activityId: String
    
    init(activityId: String)
    {
        self.activityId = activityId
    }
    
    func getActivity()
    {
        loading = true
        ActivityAPIService().getActivity(id: activityId) { [weak self] result in
            self?.loading = false
            switch result {
            case .success(let activity):
                self?.activity = activity
            case .failure(let error):
                self?.error = error
            }
        }
    }
}

//
//  ActivitiesViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 12/11/21.
//

import Foundation

class ActivitiesViewModel: BaseViewModel
{
    func getMyActivities()
    {
        loading = true
        ActivityAPIService().getMyActivities(completion: { [weak self] result in
                                                self?.loading = false
                                                switch result {
                                                case .success(let activities):
                                                    if activities.isEmpty == false {
                                                        self?.needData = false
                                                    }

                                                    let editableActivities: [Activity]? = activities.map { activity in
                                                        activity.isEditable = true
                                                        return activity
                                                    }
                                                    self?.data = editableActivities
                                                case .failure(let error):
                                                    self?.error = error
                                                }
                                            })
    }
}

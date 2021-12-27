//
//  ActivitiesViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 12/11/21.
//

import Foundation

class ActivitiesViewModel: BaseViewModel
{
    @Published var activities: [Activity]? = nil

    func getMyActivities()
    {
        loading = true
        ActivityAPIService().getMyActivities(completion: { result in
                                                self.loading = false
                                                switch result {
                                                case .success(let activities):
                                                    if activities.isEmpty == false {
                                                        self.needData = false
                                                    }

                                                    self.activities = activities.map { activity in
                                                        activity.isEditable = true
                                                        return activity
                                                    }
                                                case .failure(let error):
                                                    self.error = error
                                                }
                                            })
    }
}

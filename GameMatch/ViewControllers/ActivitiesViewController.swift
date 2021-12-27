//
//  ActivitiesViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/11/21.
//

import UIKit

class ActivitiesViewController: BaseViewController
{
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private let activitiesVM = ActivitiesViewModel()
    
    private var profileButtonItem: UIBarButtonItem?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "My Activities" // "Activities & Events"
        
        profileButtonItem = navigationItem.rightBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if SessionManager.shared.loggedIn {
            navigationItem.rightBarButtonItem = profileButtonItem
        } else {
            navigationItem.rightBarButtonItem = nil
        }

        if SessionManager.shared.loggedIn {
            if activitiesVM.needData {
                loadData()
            }
        } else {
            showLogin()
        }
    }

    private func loadData()
    {
        startSpinner()
        activitiesVM.getMyActivities(completion: { [weak self] result in
                                        self?.stopSpinner()
                                        switch result {
                                        case .success():
                                            self?.tableView.reloadData()
                                        case .failure(let error):
                                            self?.showError(error)
                                        }
                                    })
    }
    
    @IBAction func showProfile(_ sender: UIBarButtonItem)
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "ProfileNavController") as? UINavigationController {
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true, completion: nil)
        }
    }
            
    func showGroupDetails()
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "GroupDetailsViewController") as? GroupDetailsViewController {
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    func showActivityDetails(activity: Activity)
    {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ActivityDetailsViewController") as? ActivityDetailsViewController,
           let activityId = activity.id
        {
            activityScreen.setup(activityId: activityId,
                                 isEditable: true)
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
}

extension ActivitiesViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return activitiesVM.activities?.count ?? 0
//        return section == 0 ? (activitiesVM.activities?.count ?? 0) : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)

        if let cell = cell as? ActivityTableViewCell,
           let activities = activitiesVM.activities
        {
            let activity = activities[indexPath.row]
            let icon = indexPath.row % 2 == 0 ? UIImage(named: "soccerball") : UIImage(named: "hiking")

            if let name = activity.name,
               let eventStartTime = activity.eventStartTime,
               let locationName = activity.location?.name
            {
                var details = locationName
                if activity.cancelled == true {
                    details += " (canceled)"
                }
                cell.config(icon: icon,
                            title: name + " - " + eventStartTime.display(),
                            details: details)
            }
        }

//        if let cell = cell as? ActivityTableViewCell {
//            if indexPath.row % 2 == 0 {
//                let title = indexPath.section == 0 ? "Soccer Sunday" : "Soccer Pickup Game - Today 12:30pm"
//                let details = indexPath.section == 0 ? "36 members" : "Rancho Sports Park, San Ramon"
//                cell.config(icon: UIImage(named: "soccerball"),
//                            title: title,
//                            details: details)
//            } else {
//                let title = indexPath.section == 0 ? "Hiking Saturday" : "Weekend Hiking - Saturday 8/14/2021"
//                let details = indexPath.section == 0 ? "208 members" : "Mt. Dana, Yosemite"
//                cell.config(icon: UIImage(named: "hiking"),
//                            title: title,
//                            details: details)
//            }
//        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        return section == 0 ? "My Activities" : "My Events"
//    }
}

extension ActivitiesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        if let activities = activitiesVM.activities {
            let activity = activities[indexPath.row]
            showActivityDetails(activity: activity)
        }
        
//        if indexPath.section == 0 {
//            showGroupDetails()
//        } else {
//            showActivityDetails()
//        }
    }
}

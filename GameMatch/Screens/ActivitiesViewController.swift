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
    
    private var profileButtonItem: UIBarButtonItem?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Groups & Activities"
        
        profileButtonItem = navigationItem.rightBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if SessionManager.shared.sessionId == nil {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = profileButtonItem
        }
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
    
    func showActivityDetails()
    {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ActivityDetailsViewController") as? ActivityDetailsViewController {
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
}

extension ActivitiesViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section == 0 ? 2 : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        if let cell = cell as? ActivityTableViewCell {
            if indexPath.row % 2 == 0 {
                let title = indexPath.section == 0 ? "Soccer Sunday" : "Soccer Pickup Game - Today 12:30pm"
                let details = indexPath.section == 0 ? "36 members" : "Rancho Sports Park, San Ramon"
                cell.config(icon: UIImage(named: "soccerball"),
                            title: title,
                            details: details)
            } else {
                let title = indexPath.section == 0 ? "Hiking Saturday" : "Weekend Hiking - Saturday 8/14/2021"
                let details = indexPath.section == 0 ? "208 members" : "Mt. Dana, Yosemite"
                cell.config(icon: UIImage(named: "hiking"),
                            title: title,
                            details: details)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section == 0 ? "My Groups" : "My Activities"
    }
}

extension ActivitiesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            showGroupDetails()
        } else {
            showActivityDetails()
        }
    }
}

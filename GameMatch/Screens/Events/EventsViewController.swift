//
//  EventsViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/30/21.
//

import UIKit

class EventsViewController: UIViewController
{
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Soccer Pickup"
    }
    
    func showActivityDetails() {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ActivityDetailsViewController") as? ActivityDetailsViewController {
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
}

extension EventsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        if let cell = cell as? ActivityTableViewCell {
            if indexPath.section == 0 {
                let title = "09/25/2012 12:30pm"
                let details = "Rancho Sports Park, San Ramon"
                cell.config(icon: UIImage(named: "soccerball"),
                            title: title,
                            details: details,
                            count: "18")
            } else {
                let title = "07/25/2012 12:30pm"
                let details = "Rancho Sports Park, San Ramon"
                cell.config(icon: UIImage(named: "soccerball"),
                            title: title,
                            details: details,
                            count: "24")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Upcoming" : "Past"
    }
}

extension EventsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showActivityDetails()
    }
}

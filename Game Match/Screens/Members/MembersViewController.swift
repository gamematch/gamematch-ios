//
//  MembersViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/29/21.
//

import UIKit

class MembersViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Members"
    }
}

extension MembersViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 18 : 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath)

        if let cell = cell as? MemberTableViewCell {
            cell.config(icon: "soccerplayer\(indexPath.row % 4)",
                        name: "Soccer Player\(indexPath.row)",
                        info: "408-789-00\(indexPath.row + 10)",
                        date: indexPath.section == 0 ? "08/22/2021" : "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Joined (18)" : "Pending (40)"
    }
}

extension MembersViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "ProfileNavController") as? UINavigationController {
            present(nextScreen, animated: true)
        }
    }
}

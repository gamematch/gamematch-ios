//
//  GroupDetailsViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/28/21.
//

import UIKit

class GroupDetailsViewController: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!

    private var headerStartHeight: CGFloat = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()

        headerStartHeight = headerHeight.constant
        tableView.separatorStyle = .singleLine
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func showActivityDetails() {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ActivityDetailsViewController") as? ActivityDetailsViewController {
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        if let newScreen = UIStoryboard(name: "Main",
                                        bundle: nil).instantiateViewController(identifier: "CreateActivityNavController") as? UINavigationController {
            present(newScreen, animated: true, completion: nil)
        }
    }
    
    func showNewEvent() {
        if let newScreen = UIStoryboard(name: "Main",
                                        bundle: nil).instantiateViewController(identifier: "NewEventNavController") as? UINavigationController {
            present(newScreen, animated: true, completion: nil)
        }
    }
    
    func showMembers() {
        if let newScreen = UIStoryboard(name: "Main",
                                        bundle: nil).instantiateViewController(identifier: "MembersViewController") as? MembersViewController {
            navigationController?.pushViewController(newScreen, animated: true)
        }
    }
    
    func showEvents() {
        if let newScreen = UIStoryboard(name: "Main",
                                        bundle: nil).instantiateViewController(identifier: "EventsViewController") as? EventsViewController {
            navigationController?.pushViewController(newScreen, animated: true)
        }
    }
}

extension GroupDetailsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = indexPath.section == 0 ? "GroupInfoTableViewCell" : "EventTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? GroupInfoTableViewCell {
            cell.newEvent = { [weak self] in
                self?.showNewEvent()
            }
            
            cell.showMembers = { [weak self] in
                self?.showMembers()
            }
            
            cell.showEvents = { [weak self] in
                self?.showEvents()
            }
        }
        return cell
    }
}

extension GroupDetailsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            showActivityDetails()
        }
    }
}

extension GroupDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        if offsetY == 0 {
            return
        }
        let expectedHeight = headerStartHeight + offsetY
        if expectedHeight > 80 {
            headerHeight.constant = expectedHeight
        }
    }
}

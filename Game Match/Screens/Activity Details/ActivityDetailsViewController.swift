//
//  ActivityDetailsViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/12/21.
//

import UIKit

class ActivityDetailsViewController: UIViewController
{    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    private var headerStartHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerStartHeight = headerHeight.constant
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
            
    func showContacts() {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ContactsViewController") as? ContactsViewController {
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
    
    func sendMessage() {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "SendMessageNavController") as? UINavigationController {
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true)
        }
    }
    
    func showLogin() {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "LoginNavController") as? UINavigationController {
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true, completion: nil)
        }
    }
}

extension ActivityDetailsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ActivityDetailsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = indexPath.section == 0 ? "ActivityInfoTableViewCell" : "MessageTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? ActivityInfoTableViewCell {
            cell.shareActivity = { [weak self] in
                let textToShare = "Soccer Pickup Game"

                if let myWebsite = URL(string: "http://www.codingexplorer.com/") {
                    let objectsToShare: [Any] = [textToShare, myWebsite]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                    activityVC.popoverPresentationController?.sourceView = cell
                    self?.present(activityVC, animated: true, completion: nil)
                }
            }
            
            cell.joinActivity = { [weak self] in
                self?.showLogin()
            }
            
            cell.invite = { [weak self] in
                self?.showContacts()
            }
            
            cell.sendMessage = { [weak self] in
                self?.sendMessage()
            }
        }
        
        if let cell = cell as? MessageTableViewCell {
            cell.config(icon: "soccerplayer\(indexPath.row % 4)",
                        name: "Player\(indexPath.row + 1)",
                        time: "8/10 10:3\(indexPath.row)",
                        message: "Game On! In+\(indexPath.row + 1)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Messages"
    }
}

extension ActivityDetailsViewController: UIScrollViewDelegate {
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

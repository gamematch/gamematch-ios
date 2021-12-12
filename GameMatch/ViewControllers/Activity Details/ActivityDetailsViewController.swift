//
//  ActivityDetailsViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/12/21.
//

import UIKit

class ActivityDetailsViewController: BaseViewController
{    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    private var activityDetailsVM: ActivityDetailsViewModel?
    
    private var headerStartHeight: CGFloat = 0
    
    func setup(activityId: String)
    {
        activityDetailsVM = ActivityDetailsViewModel(activityId: activityId)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        headerStartHeight = headerHeight.constant
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func loadData()
    {
        if let activityDetailsVM = activityDetailsVM {
            startSpinner()
            activityDetailsVM.getActivity { [weak self] result in
                self?.stopSpinner()
                switch result {
                case .success():
                    let status = activityDetailsVM.activity?.isCancelled == true ? " (Canceled)" : ""
                    self?.nameLabel.text = (activityDetailsVM.activity?.name ?? "") + status
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
            
    func showContacts()
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "ContactsViewController") as? ContactsViewController {
            nextScreen.setup(activity: activityDetailsVM?.activity)
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    func sendMessage()
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "SendMessageNavController") as? UINavigationController {
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true)
        }
    }
    
    func showLogin()
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "LoginNavController") as? UINavigationController {
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true, completion: nil)
        }
    }

    @IBAction func editAction()
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                        bundle: nil).instantiateViewController(identifier: "ModifyActivityNavController") as? UINavigationController,
           let controller = nextScreen.topViewController as? ModifyActivityViewController
        {
            controller.setup(activity: activityDetailsVM?.activity)
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true, completion: nil)
        }
    }
}

extension ActivityDetailsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ActivityDetailsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellId = indexPath.section == 0 ? "ActivityInfoTableViewCell" : "MessageTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? ActivityInfoTableViewCell {
            if let startTime = activityDetailsVM?.activity?.eventStartTime,
               let endTime = activityDetailsVM?.activity?.eventEndTime,
               let location = activityDetailsVM?.activity?.location?.name
            {
                cell.config(startTime: startTime,
                            endTime: endTime,
                            location: location)
            }
            
            cell.shareActivity = { [weak self] in
                let textToShare = self?.activityDetailsVM?.activity?.name ?? ""

                if let invitationUrl = self?.activityDetailsVM?.activity?.invitationUrl,
                   let invitationWeb = URL(string: invitationUrl)
                {
                    let objectsToShare: [Any] = [textToShare, invitationWeb]
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
        } else if let cell = cell as? MessageTableViewCell {
            cell.config(icon: "soccerplayer\(indexPath.row % 4)",
                        name: "Player\(indexPath.row + 1)",
                        time: "8/10 10:3\(indexPath.row)",
                        message: "Game On! In+\(indexPath.row + 1)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section == 0 ? nil : "Messages"
    }
}

extension ActivityDetailsViewController: UIScrollViewDelegate
{
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

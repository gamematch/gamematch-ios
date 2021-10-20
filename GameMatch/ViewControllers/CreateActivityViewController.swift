//
//  CreateActivityViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/12/21.
//

import UIKit

class CreateActivityViewController: BaseViewController
{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    private let createActivityVM = CreateActivityViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.cornerRadius = 3

        navigationItem.title = "Create Activity"
    }
    
    @IBAction func closeAction(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any)
    {
        if let latitude = LocationService.shared.locationManager?.location?.coordinate.latitude,
           let longitude = LocationService.shared.locationManager?.location?.coordinate.longitude,
           let name = nameField.text,
           let address = addressField.text
        {
            startSpinner()
            createActivityVM.createActivity(latitude: latitude,
                                            longitude: longitude,
                                            name: name,
                                            address: address) { [weak self] result in
                                                self?.stopSpinner()
                                                switch result {
                                                case .success(let activity):
                                                    print("======== New Activity ID: \(activity.id) =========")
                                                    self?.dismiss(animated: true, completion: nil)
                                                case .failure(let error):
                                                    self?.showError(error)
                                                }
                                            }
        }
    }
    
    @IBAction func inviteAction(_ sender: Any)
    {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ContactsViewController") as? ContactsViewController {
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
}

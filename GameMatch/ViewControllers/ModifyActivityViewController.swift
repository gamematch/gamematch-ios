//
//  ModifyActivityViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/12/21.
//

import UIKit

class ModifyActivityViewController: BaseViewController
{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!

    private var modifyActivityVM: ModifyActivityViewModel?

    func setup(activity: Activity?)
    {
        modifyActivityVM = ModifyActivityViewModel(activity: activity)

        navigationItem.title = "Edit Activity"

        nameField.text = modifyActivityVM?.activity?.name

        locationNameField.text = modifyActivityVM?.activity?.location?.name
        addressField.text = modifyActivityVM?.activity?.location?.address

        if let latitude = modifyActivityVM?.activity?.location?.latitude {
            latitudeField.text = String(latitude)
        }

        if let longitude = modifyActivityVM?.activity?.location?.longitude {
            longitudeField.text = String(longitude)
        }

        if let eventStartTime = modifyActivityVM?.activity?.eventStartTime {
            dateField.text = eventStartTime.display(format: "MM/dd/yyyy")
            timeField.text = eventStartTime.display(format: "h:mma")
        }

        deleteButton.isHidden = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.cornerRadius = 3

        if modifyActivityVM == nil {
            modifyActivityVM = ModifyActivityViewModel()
            navigationItem.title = "Create Activity"
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func closeAction(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any)
    {
        let latitudeInput = Double(latitudeField.text ?? "")
        let longitudeInput = Double(longitudeField.text ?? "")
        
        if let name = nameField.text,
           let locationName = locationNameField.text,
           let latitude = latitudeInput ?? LocationService.shared.locationManager?.location?.coordinate.latitude,
           let longitude = longitudeInput ?? LocationService.shared.locationManager?.location?.coordinate.longitude,
           let modifyActivityVM = modifyActivityVM
        {
            startSpinner()
            modifyActivityVM.modifyActivity(name: name,
                                            locationName: locationName,
                                            latitude: latitude,
                                            longitude: longitude,
                                            address: addressField.text) { [weak self] result in
                                                self?.stopSpinner()
                                                switch result {
                                                case .success(let activity):
                                                    print("======== Activity ID: \(String(describing: activity.id)) =========")
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

    @IBAction func deleteAction(_ sender: Any)
    {
        if let modifyActivityVM = modifyActivityVM {
            startSpinner()
            modifyActivityVM.deleteActivity() { [weak self] result in
                                                self?.stopSpinner()
                                                switch result {
                                                case .success:
                                                    self?.dismiss(animated: true,
                                                                  completion: {
                                                                      self?.navigationController?.popToRootViewController(animated: true)
                                                                  })
                                                case .failure(let error):
                                                    self?.showError(error)
                                                }
                                            }
        }
    }
}

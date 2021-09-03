//
//  CreateActivityViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/12/21.
//

import UIKit

class CreateActivityViewController: UIViewController
{
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.cornerRadius = 3

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Create Activity"
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ContactsViewController") as? ContactsViewController {
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
}

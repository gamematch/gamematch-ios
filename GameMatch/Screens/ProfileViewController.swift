//
//  ProfileViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/11/21.
//

import UIKit

class ProfileViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Profile"
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

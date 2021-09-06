//
//  SetupViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/24/21.
//

import UIKit

class SetupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Sign Up"
    }
    
    @IBAction func setupAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

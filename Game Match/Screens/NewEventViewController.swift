//
//  NewEventViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/29/21.
//

import UIKit

class NewEventViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "New Event"
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

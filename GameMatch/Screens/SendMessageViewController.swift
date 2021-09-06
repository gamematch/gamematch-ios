//
//  SendMessageViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/26/21.
//

import UIKit

class SendMessageViewController: UIViewController
{
    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Send Message"
        
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 3
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

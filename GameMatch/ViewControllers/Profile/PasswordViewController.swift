//
//  PasswordViewController.swift
//  GameMatch
//
//  Created by Luke Shi on 1/6/22.
//

import UIKit

class PasswordViewController: BaseViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Change Password"
    }

    @IBAction func changeAction()
    {
        navigationController?.popViewController(animated: true)
    }
}

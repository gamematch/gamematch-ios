//
//  BaseViewController.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import UIKit

class BaseViewController: UIViewController
{
    open override func awakeFromNib()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func showMessage(title: String = "", _ message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ error: Error)
    {
        if let error = error as? GMError {
            showMessage(error.message)
        } else {
            showMessage(error.localizedDescription)
        }
    }
}

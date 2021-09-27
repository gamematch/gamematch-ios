//
//  SignInViewController.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import UIKit

class SignInViewController: BaseViewController
{
    @IBOutlet weak var identityLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    
    private let signinVM = SignInViewModel()
    
    func setup(identity: String)
    {
        signinVM.identity = identity
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Welcome Back"
        
        identityLabel.text = signinVM.identity
    }
    
    @IBAction func nextAction()
    {
        if let identity = signinVM.identity,
           let password = passwordField.text
        {
            signinVM.login(identity: identity,
                           password: password,
                           completion: { [weak self] result in
                               switch result {
                               case .success(let state):
                                   print("========= sessionId: \(state.sessionId) =========")
                                   self?.dismiss(animated: true, completion: nil)
                               case .failure(let error):
                                   self?.showError(error)
                               }
                           })
        }
    }
}

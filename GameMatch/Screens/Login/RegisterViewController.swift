//
//  RegisterViewController.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import UIKit

class RegisterViewController: BaseViewController
{
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    private let signinVM = SignInViewModel()
    
    func setup(identity: String)
    {
        signinVM.identity = identity
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Register"
    }
    
    @IBAction func registerAction()
    {
        if let identity = signinVM.identity,
           let code = codeField.text,
           let name = nameField.text,
           let password = passwordField.text
        {
            signinVM.register(identity: identity,
                              code: code,
                              name: name,
                              password: password,
                              completion: { [weak self] result in
                                switch result {
                                case .success(let state):
                                    print("========= status: \(state.userId) =========")
                                    self?.dismiss(animated: true,
                                                  completion: nil)
                                case .failure(let error):
                                    print(error)
                                }
                             })
        }
    }
}

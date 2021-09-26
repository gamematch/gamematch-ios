//
//  LoginViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/23/21.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: BaseViewController
{
    @IBOutlet weak var identityField: UITextField!
    @IBOutlet weak var facebookLoginView: UIView!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    private let signinVM = SignInViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Let's Get Started"

        let loginButton = FBLoginButton()
        loginButton.center = CGPoint(x: facebookLoginView.bounds.width / 2,
                                     y: facebookLoginView.bounds.height / 2)
        facebookLoginView.addSubview(loginButton)
        
        loginButton.permissions = ["public_profile", "email"]

        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            print("========= User is logged in =========")
        } else {
            print("========= User is NOT logged in =========")
        }
    }
    
    @IBAction func googleLoginAction(_ sender: Any) {
        let signInConfig = GIDConfiguration.init(clientID: "YOUR_IOS_CLIENT_ID")
        GIDSignIn.sharedInstance.signIn(with: signInConfig,
                                        presenting: self)
        { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            // Your user is signed in!
            print("===== user: \(user) logged in ======")
        }
    }
    
    @IBAction func nextAction() {
        if let identity = identityField.text {
            signinVM.signup(identity: identity,
                            completion: { [weak self] result in
                                switch result {
                                case .success(let state):
                                    print("========= status: \(state.status) =========")
                                    if state.status == "ACTIVATION_CODE_SENT" {
                                        self?.showRegisterScreen(identity: identity)
                                    } else if state.status == "USER_ALREADY_EXISTED" {
                                        self?.showSignInScreen(identity: identity)
                                    } else {
                                        self?.showMessage("Data Error")
                                    }
                                case .failure(let error):
                                    self?.showError(error)
                                }
                            })
        }
    }
    
    private func showSignInScreen(identity: String) {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "SignInViewController") as? SignInViewController {
            nextScreen.setup(identity: identity)
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showRegisterScreen(identity: String)
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController {
            nextScreen.setup(identity: identity)
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
}

//
//  LoginViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/23/21.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController
{
    @IBOutlet weak var facebookLoginView: UIView!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Login"

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
    
    @IBAction func loginAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setupAction(_ sender: Any) {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "SetupViewController") as? SetupViewController {
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

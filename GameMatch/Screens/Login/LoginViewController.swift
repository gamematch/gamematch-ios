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

        if let token = AccessToken.current, !token.isExpired {
            printFBAccessToken(token)
        } else {
            print("========= User is NOT logged in FB =========")
        }
        
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange,
                                               object: nil,
                                               queue: OperationQueue.main) { notification in
            print("======== notification: \(notification) =========")
            if let token = AccessToken.current {
                self.printFBAccessToken(token)
            }
        }
    }
    
    private func printFBAccessToken(_ token: AccessToken)
    {
        print("tokenString: \(String(describing: token.tokenString))")
        print("userID: \(String(describing: token.userID))")
        print("appID: \(String(describing: token.appID))")
        print("expirationDate: \(String(describing: token.expirationDate))")
        print("permissions: \(String(describing: token.permissions))")
        
        let req = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"],
                               tokenString: token.tokenString,
                               version: nil,
                               httpMethod: .get)
        req.start { [weak self] connection, result, error in
            if let error = error {
                print("=== error \(String(describing: error))")
            } else if let result = result as? [String: String],
                      let name = result["name"], let email = result["email"] {
                self?.showMessage(title: "Facebook User", "\(name)\n\(email)\n\(token.userID)")
            }
        }
    }
    
    @IBAction func googleLoginAction(_ sender: Any)
    {
        let signInConfig = GIDConfiguration.init(clientID: "971918164052-2866me8ce54b04tb7m2evvep0q8aftfd.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig,
                                        presenting: self) { [weak self] user, error in
            if let error = error {
                print("=== error \(String(describing: error))")
            } else if let name = user?.profile?.name, let email = user?.profile?.email,
                      let userId = user?.userID {
                self?.showMessage(title: "Google User", "\(name)\n\(email)\n\(userId)")
            }
        }
    }
    
    @IBAction func nextAction()
    {
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
    
    private func showSignInScreen(identity: String)
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "SignInViewController") as? SignInViewController {
            nextScreen.setup(identity: identity)
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    @IBAction func closeAction(_ sender: Any)
    {
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

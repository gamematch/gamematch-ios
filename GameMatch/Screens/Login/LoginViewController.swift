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

        if let token = AccessToken.current, !token.isExpired {
            loginWithFacebook(token: token)
        }

        let loginButton = FBLoginButton()
        loginButton.center = CGPoint(x: facebookLoginView.bounds.width / 2,
                                     y: facebookLoginView.bounds.height / 2)
        facebookLoginView.addSubview(loginButton)
        
        loginButton.permissions = ["public_profile", "email"]
        
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange,
                                               object: nil,
                                               queue: OperationQueue.main) { notification in
            if let token = AccessToken.current {
                self.loginWithFacebook(token: token)
            }
        }
    }
    
    private func loginWithFacebook(token: AccessToken)
    {
//        print("tokenString: \(String(describing: token.tokenString))")
//        print("userID: \(String(describing: token.userID))")
//        print("appID: \(String(describing: token.appID))")
//        print("expirationDate: \(String(describing: token.expirationDate))")
//        print("permissions: \(String(describing: token.permissions))")
        
        let req = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"],
                               tokenString: token.tokenString,
                               version: nil,
                               httpMethod: .get)
        req.start { [weak self] connection, result, error in
            if let error = error {
                self?.showError(error)
            } else if let result = result as? [String: String], let name = result["name"], let email = result["email"] {
                self?.signinVM.signup(socialNetwork: .facebook,
                                      identity: email,
                                      name: name,
                                      userId: token.userID,
                                      completion: { [weak self] result in
                                          switch result {
                                          case .success:
                                              self?.dismiss(animated: true, completion: nil)
                                          case .failure(let error):
                                              self?.showError(error)
                                          }
                                      })
            }
        }
    }
    
    @IBAction func googleLoginAction(_ sender: Any)
    {
        let googleClientId = "971918164052-2866me8ce54b04tb7m2evvep0q8aftfd.apps.googleusercontent.com"
        let signInConfig = GIDConfiguration.init(clientID: googleClientId)
        GIDSignIn.sharedInstance.signIn(with: signInConfig,
                                        presenting: self) { [weak self] user, error in
            if let error = error {
                self?.showError(error)
            } else if let name = user?.profile?.name, let email = user?.profile?.email, let userId = user?.userID {
                self?.signinVM.signup(socialNetwork: .google,
                                      identity: email,
                                      name: name,
                                      userId: userId,
                                      completion: { [weak self] result in
                                          switch result {
                                          case .success:
                                              self?.dismiss(animated: true, completion: nil)
                                          case .failure(let error):
                                              self?.showError(error)
                                          }
                                      })
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

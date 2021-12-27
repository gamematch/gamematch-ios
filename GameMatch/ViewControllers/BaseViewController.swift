//
//  BaseViewController.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import UIKit
import NVActivityIndicatorView
import Combine

class BaseViewController: UIViewController
{
    var viewModel: BaseViewModel!
    var cancellables: Set<AnyCancellable> = []

    private var spinner = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    open override func awakeFromNib()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        spinner.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        spinner.color = traitCollection.userInterfaceStyle == .light ? .gray : .white
        view.addSubview(spinner)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupViewModel()
        bindViewModel()
    }

    func setupViewModel()
    {
        self.viewModel = BaseViewModel()
    }

    func bindViewModel()
    {
        viewModel.$loading.sink { loading in
            DispatchQueue.main.async {
                if loading {
                    self.startSpinner()
                } else {
                    self.stopSpinner()
                }
            }
        }.store(in: &cancellables)

        viewModel.$error.sink { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showError(error)
                }
            }
        }.store(in: &cancellables)
    }
    
    func startSpinner()
    {
        spinner.startAnimating()
    }
    
    func stopSpinner()
    {
        spinner.stopAnimating()
    }

    func showMessage(title: String = "",
                     _ message: String,
                     completion: (() -> Void)? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: { _ in
                                          completion?()
                                      }))
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

    func showLogin()
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "LoginNavController") as? UINavigationController {
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true, completion: nil)
        }
    }
}

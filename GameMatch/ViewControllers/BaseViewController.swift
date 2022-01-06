//
//  BaseViewController.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import UIKit
import NVActivityIndicatorView
import Combine

typealias MenuAction = (title: String, actionStyle: UIAlertAction.Style, action: (() -> Void)?)

class BaseViewController: UIViewController
{
    var viewModel: BaseViewModel?
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
        viewModel?.$loading.sink { loading in
            DispatchQueue.main.async {
                if loading {
                    self.startSpinner()
                } else {
                    self.stopSpinner()
                }
            }
        }.store(in: &cancellables)

        viewModel?.$error.sink { error in
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

    @discardableResult
    func showAlertController(title: String? = nil,
                             with selections: [MenuAction],
                             enableCancel: Bool = true) -> UIAlertController
    {
        let menu = createMenu(title: title, selections: selections, withCancel: enableCancel)

        // Below 2 lines will work only for iPad as popoverPresentationController only exists in iPad
        menu.popoverPresentationController?.sourceView = self.view
        menu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)

        // Hide the directional arrow
        menu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()

        present(menu, animated: true, completion: nil)

        return menu
    }

    private func createMenu(title: String?,
                            selections: [MenuAction],
                            withCancel: Bool) -> UIAlertController
    {
        let menu = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        for selection in selections
        {
            let menuAction = UIAlertAction(title: selection.title, style: selection.actionStyle, handler: { _ in
                selection.action?()
            })
            menu.addAction(menuAction)
        }

        if withCancel
        {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            menu.addAction(cancelAction)
        }

        return menu
    }
}

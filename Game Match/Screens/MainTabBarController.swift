//
//  MainTabBarController.swift
//  Game Match
//
//  Created by Luke Shi on 8/17/21.
//

import UIKit

let tabBarHeight: CGFloat = 46

class MainTabBarController: UITabBarController
{
    let buttonWidth: CGFloat = 36
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        tabBar.tintColor = traitCollection.userInterfaceStyle == .light ? .black : .white
    
        setupPlusButton()
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    }

    private func setupPlusButton() {
        let plusButton = UIButton(frame: CGRect(x: (view.bounds.width - buttonWidth) / 2,
                                                y: (50 - buttonWidth) / 2,
                                                width: buttonWidth,
                                                height: buttonWidth))
        let image = traitCollection.userInterfaceStyle == .light ? UIImage(systemName: "plus.circle")
                                                                 : UIImage(systemName: "plus.circle")?.withColor(.white)
        plusButton.setBackgroundImage(image, for: .normal)
        plusButton.addTarget(self, action: #selector(addActivity), for: .touchUpInside)
        tabBar.addSubview(plusButton)

        view.layoutIfNeeded()
    }
    
    @objc func addActivity() {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "CreateActivityNavController") as? UINavigationController {
            nextScreen.modalPresentationStyle = .fullScreen
            present(nextScreen, animated: true)
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        view.layoutIfNeeded()
    }
}

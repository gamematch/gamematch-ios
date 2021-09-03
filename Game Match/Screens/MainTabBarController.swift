//
//  MainTabBarController.swift
//  Game Match
//
//  Created by Luke Shi on 8/17/21.
//

import UIKit

class MainTabBarController: UITabBarController
{
    let buttonWidth: CGFloat = 44
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        tabBar.tintColor = traitCollection.userInterfaceStyle == .light ? .black : .white
    
        setupPlusButton()
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
    }
        
    private func setupPlusButton() {
        let plusButton = UIButton(frame: CGRect(x: (view.bounds.width - buttonWidth) / 2,
                                                y: 6,
                                                width: buttonWidth,
                                                height: buttonWidth))
        let image = traitCollection.userInterfaceStyle == .light ? UIImage(systemName: "plus.circle.fill")
                                                                 : UIImage(systemName: "plus.circle.fill")?.withColor(.white)
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

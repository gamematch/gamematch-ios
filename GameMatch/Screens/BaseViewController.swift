//
//  BaseViewController.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import UIKit

class BaseViewController: UIViewController
{
    open override func awakeFromNib()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//    }
}

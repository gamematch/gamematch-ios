//
//  UIImageView+.swift
//  Game Match
//
//  Created by Luke Shi on 8/17/21.
//

import UIKit

extension UIImageView
{
    convenience init(image: UIImage?, color: UIColor? = nil)
    {
        self.init(image: image)

        if let color = color
        {
            self.image = image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }
    }
}

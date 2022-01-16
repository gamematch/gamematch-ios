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

    func load(url: URL)
    {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data)
            {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

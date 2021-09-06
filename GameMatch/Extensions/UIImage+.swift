//
//  UIImage+.swift
//  Game Match
//
//  Created by Luke Shi on 8/25/21.
//

import UIKit

extension UIImage
{
    func withColor(_ color: UIColor) -> UIImage?
    {
        var resultImage: UIImage?
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()
        if let cgImage = self.cgImage
        {
            context?.clip(to: rect, mask: cgImage)
        }

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let cgImage = image?.cgImage
        {
            resultImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .downMirrored)
        }
        else
        {
            resultImage = nil
        }

        return resultImage
    }
}

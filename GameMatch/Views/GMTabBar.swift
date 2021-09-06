//
//  GMTabBar.swift
//  Game Match
//
//  Created by Luke Shi on 8/22/21.
//

import UIKit

@IBDesignable
class GMTabBar: UITabBar
{
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else {
            return super.sizeThatFits(size)
        }

        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = tabBarHeight + window.safeAreaInsets.bottom
        return sizeThatFits
    }
}

//
//  UIView+extension.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

extension UIView {
    
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    func setBorder(color: UIColor = .baseWhite, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func applyBlurEffect(style: UIBlurEffect.Style = .dark, alpha: Double = 1) {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style)).with({
            $0.setCornerRadius(self.layer.cornerRadius)
            $0.clipsToBounds = true
            $0.frame = bounds
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.alpha = alpha
            $0.isUserInteractionEnabled = false
        })
        addSubview(blurEffectView)
    }
}

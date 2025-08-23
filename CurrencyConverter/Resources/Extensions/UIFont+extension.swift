//
//  CustomFont.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

extension UIFont {
    
    static func semibold(_ size: CGFloat) -> UIFont {
        font(size, .semibold)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        font(size, .medium)
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        font(size, .regular)
    }
    
    static func font(
        _ size: CGFloat,
        _ customFont: CustomFont
    ) -> UIFont {
        
        UIFont(name: customFont.name, size: Device.isIpad ? size + 6 : size)
        ??
        UIFont.systemFont(ofSize: Device.isIpad ? size + 6 : size, weight: .regular)
    }
}

enum CustomFont: String {
    case semibold   = "SemiBold"
    case medium     = "Medium"
    case regular    = "Regular"
    
    var name: String {
        "Hahmlet-\(self)"
    }
}

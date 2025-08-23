//
//  B.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

extension UIButton {
    
    func setAction(_ action: @escaping () -> Void) {
        let uiAction = UIAction { _ in
            action()
        }
        addAction(uiAction, for: .touchUpInside)
    }
    
    func setInsets(_ inset: CGFloat) {
        configuration = .plain()
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}

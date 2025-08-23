//
//  NavigationController.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let standardAppearance = navigationBar.standardAppearance
        standardAppearance.shadowColor = .clear
        standardAppearance.shadowImage = nil
        standardAppearance.backgroundColor = .clear
        standardAppearance.backgroundEffect = nil
        
        standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.baseWhite,
            .font: UIFont.semibold(20)
        ]
    }
}

//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by Irina on 14.08.2025.
//

import UIKit

struct AppCoordinator {
    
    private let navigationController = NavigationController()
    private let window: UIWindow?
    
    init(
        windowScene: UIWindowScene
    ) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
    }
    
    func goToStartScreen() {
        StartScreenCoordinator(navigationController: navigationController).start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Irina on 14.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private var coordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        coordinator = .init(windowScene: windowScene)
        coordinator?.goToStartScreen()
    }
}

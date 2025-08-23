//
//  StartScreenCoordinator.swift
//  CurrencyConverter
//
//  Created by Irina on 14.08.2025.
//

import UIKit

struct StartScreenCoordinator: AlertProtocol {
    
    var navigationController: NavigationController
    
    init(
        navigationController: NavigationController
    ) {
        self.navigationController = navigationController
    }
    
    func start() {
        let view = StartScreenViewController()
        let presenter = StartScreenPresenter()
        
        presenter.coordinator = self
        presenter.view = view
        view.presenter = presenter
        
        navigationController.viewControllers = [view]
    }
    
    func goToCurrenciesList(currencyType: CurrencyType, currencies: [Currency], delegate: CurrenciesListModuleDelegate) {
        CurrenciesListCoordinator(navigationController: navigationController, currencyType: currencyType, currencies: currencies, delegate: delegate).start()
    }
    
    func showAlert(
        title: String?,
        message: String?
    ) {
        DispatchQueue.main.async(execute: {
            presentAlert(
                title: title,
                message: message,
                actions: [.okAction]
            )
        })
    }
}

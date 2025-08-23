//
//  CurrenciesListCoordinator.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

struct CurrenciesListCoordinator {
    
    var navigationController: NavigationController
    
    private var currencyType: CurrencyType
    private var currencies: [Currency]
    private weak var delegate: CurrenciesListModuleDelegate?
    
    init(
        navigationController: NavigationController,
        currencyType: CurrencyType,
        currencies: [Currency],
        delegate: CurrenciesListModuleDelegate?
    ) {
        self.navigationController = navigationController
        self.currencyType = currencyType
        self.currencies = currencies
        self.delegate = delegate
    }
    
    func start() {
        let view = CurrenciesListViewController(currencies: currencies, currencyType: currencyType)
        let presenter = CurrenciesListPresenter(currencyType: currencyType, currencies: currencies, delegate: delegate)
        
        presenter.coordinator = self
        presenter.view = view
        view.presenter = presenter
        
        navigationController.present(view, animated: true)
    }
    
    func closeCurrenciesList() {
        navigationController.dismiss(animated: true)
    }
}

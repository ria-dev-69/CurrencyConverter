//
//  CurrenciesListPresenter.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

protocol CurrenciesListModuleDelegate: AnyObject {
    func didSelect(currency: Currency, currencyType: CurrencyType)
}

protocol CurrenciesListPresenterOutput: PresenterOutput {
    func updateView(currencies: [Currency])
}

class CurrenciesListPresenter {
    
    private var currencyType: CurrencyType
    private var currencies: [Currency]
    private var filteredCurrencies = [Currency]()
    
    var coordinator: CurrenciesListCoordinator?
    weak var view: CurrenciesListPresenterOutput?
    weak var delegate: CurrenciesListModuleDelegate?
    
    init(
        currencyType: CurrencyType,
        currencies: [Currency],
        delegate: CurrenciesListModuleDelegate?
    ) {
        self.currencyType = currencyType
        self.currencies = currencies
        self.delegate = delegate
    }
}

//MARK: - CurrenciesListViewControllerEvents
extension CurrenciesListPresenter: CurrenciesListViewControllerEvents {
    
    func didTapCross() {
        coordinator?.closeCurrenciesList()
    }
    
    func didSelect(currency: Currency) {
        delegate?.didSelect(currency: currency, currencyType: currencyType)
        coordinator?.closeCurrenciesList()
    }
    
    func didUpdate(searchText: String) {
        view?.updateView(
            currencies: searchText.isEmpty
                ? currencies
                : currencies.filter { $0.currencyName.lowercased().contains(searchText.lowercased()) }
        )
    }
}

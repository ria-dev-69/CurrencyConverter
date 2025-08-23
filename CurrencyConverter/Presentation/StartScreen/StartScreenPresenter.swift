//
//  StartScreenPresenter.swift
//  CurrencyConverter
//
//  Created by Irina on 14.08.2025.
//

import UIKit

protocol StartScreenPresenterOutput: PresenterOutput {
    func hideLoader(isUserInteractionEnabled: Bool)
    func updateView(fromCurrency: String, toCurrency: String)
    func updateView(result: Double)
    func animateEqualityIndicator(needShow: Bool)
}

class StartScreenPresenter {
    
    private var currencies = [Currency]()
    private var fromCurrency: Currency?
    private var toCurrency: Currency?
    private var conversionRate: Double?
    private var amount: Double? {
        didSet {
            if let amount = amount, let conversionRate = conversionRate {
                view?.updateView(result: amount * conversionRate)
            } else {
                view?.updateView(result: 0)
            }
        }
    }
    
    var coordinator: StartScreenCoordinator?
    weak var view: StartScreenPresenterOutput?
    
    init() {
        ConversionManager.getCurrenciesList(onSuccess: { [weak self] currencies in
            self?.currencies = currencies.sorted(by: { $0.currencyName < $1.currencyName })
            self?.view?.hideLoader(isUserInteractionEnabled: true)
        }, onError: { [weak self] in
            self?.view?.hideLoader(isUserInteractionEnabled: false)
            self?.coordinator?.showAlert(
                title: "Failed to load list of currencies",
                message: "The API key may have expired"
            )
        })
    }
}

private extension StartScreenPresenter {
    
    func updateViewAndGetActualConversionRate() {
        view?.updateView(fromCurrency: fromCurrency?.currencyCode ?? "?", toCurrency: toCurrency?.currencyCode ?? "?")
        if let fromCurrency = fromCurrency, let toCurrency = toCurrency {
            getActualConversionRate(from: fromCurrency.currencyCode, to: toCurrency.currencyCode)
        }
    }
    
    func getActualConversionRate(from: String, to: String) {
        view?.animateEqualityIndicator(needShow: true)
        ConversionManager.getConversionRate(
            from: from,
            to: to,
            onSuccess: { [weak self] conversionRate in
                guard let self else { return }
                view?.animateEqualityIndicator(needShow: false)
                self.conversionRate = conversionRate
                if let amount = amount {
                    view?.updateView(result: amount * conversionRate)
                } else {
                    view?.updateView(result: 0)
                }
            }, onError: { [weak self] in
                guard let self else { return }
                view?.animateEqualityIndicator(needShow: false)
                fromCurrency = nil
                toCurrency = nil
                view?.updateView(fromCurrency: "?", toCurrency: "?")
                coordinator?.showAlert(
                    title: "An error occurred",
                    message: "Please, try again"
                )
            }
        )
    }
}

extension StartScreenPresenter: CurrenciesListModuleDelegate {
    
    func didSelect(currency: Currency, currencyType: CurrencyType) {
        var currencyDidChanged = false
        
        switch currencyType {
        case .from:
            if fromCurrency != currency {
                fromCurrency = currency
                currencyDidChanged = true
            }
        case .to:
            if toCurrency != currency {
                toCurrency = currency
                currencyDidChanged = true
            }
        }
        
        guard currencyDidChanged else { return }
        updateViewAndGetActualConversionRate()
    }
}

//MARK: - StartScreenViewControllerEvents
extension StartScreenPresenter: StartScreenViewControllerEvents {
    
    func viewDidLoad() {
        DeviceService.setDeviceParametres()
    }
    
    func didTapReverse() {
        let extraCurrency = toCurrency
        toCurrency = fromCurrency
        fromCurrency = extraCurrency
        updateViewAndGetActualConversionRate()
    }
    
    func didTapChooseCurrencyButton(currencyType: CurrencyType) {
        coordinator?.goToCurrenciesList(currencyType: currencyType, currencies: currencies, delegate: self)
    }
    
    func shouldChangeText(
        _ textField: UITextField,
        _ range: NSRange,
        _ string: String
    ) -> Bool {
        //запрет на вставку более чем одного символа
        if let text = textField.text, string.count <= 1 {
            
            //ограничение на колличество вводимых символов
            let maxNumbersCount = 10
            if text.count >= maxNumbersCount {
                
                return string.isEmpty
            }
            
            //ввод числа с дробной частью
            if !text.contains(".") {
                if ["0", ",", "."].contains(string), range.location == 0 { //число меньше 1 -> ввод 0 с точкой
                    textField.text = "0." + (textField.text ?? "")
                    
                    return false
                } else if [",", "."].contains(string), range.location > 0 { //число больше 1 -> ввод точки
                    textField.text?.append(".")
                    
                    return false
                }
            }
            
            //запрет на ввод символов перед/между "0."
            if text.prefix(2) == "0.", range.location < 2 {
                
                //удалять точку вместе с 0
                if string.isEmpty {
                    textField.text = String(text.suffix(text.count - 2))
                }
                
                return false
            }
            
            //не более двух знаков после точки
            if let indexOfDot = text.firstIndex(of: ".")?.utf16Offset(in: text), text.count - indexOfDot > 2 {
                
                return string.isEmpty
            }
            
            //можно ввести арабскую цифру или стреть символ (проверка актуальна при наличии на устройстве сторонних клавиатур)
            return ["0","1","2","3","4","5","6","7","8","9"].contains(string) || string.isEmpty
        }
        
        return false
    }
    
    func textDidChange(text: String?) {
        if let text = text, let amount = Double(text) {
            self.amount = amount
        } else {
            amount = nil
        }
    }
}

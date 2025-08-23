//
//  ConversionManager.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import Foundation

struct ConversionManager {
    
    static func getCurrenciesList(
        onSuccess: @escaping ([Currency]) -> Void,
        onError: @escaping () -> Void
    ) {
        Provider.conversionProvider.request(
            .getCurrencies,
            CurrenciesListResponse.self,
            onSuccess: { response in
                var currencies = [Currency]()
                for element in response.supportedCodes {
                    currencies.append(Currency(currencyCode: element[0], currencyName: element[1]))
                }
                onSuccess(currencies)
            },
            onError: { error in
                print("Fail getting currencies list. Error: \(error.localizedDescription)")
                onError()
            }
        )
    }
    
    static func getConversionRate(
        from: String,
        to: String,
        onSuccess: @escaping (Double) -> Void,
        onError: @escaping () -> Void
    ) {
        Provider.conversionProvider.request(
            .getConversionRate(from: from, to: to),
            ConversionRateResponse.self,
            onSuccess: { response in
                onSuccess(response.conversionRate)
            },
            onError: { error in
                print("Fail getting conversion rate. Error: \(error.localizedDescription)")
                onError()
            }
        )
    }
}

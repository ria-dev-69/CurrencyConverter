//
//  CurrenciesListResponse.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

struct CurrenciesListResponse: Codable {
    let result: String
    let documentation: String
    let termsOfUse: String
    let supportedCodes: [[String]]
    
    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case supportedCodes = "supported_codes"
    }
}

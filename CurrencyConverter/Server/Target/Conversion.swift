//
//  Conversion.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import Moya
import Foundation

enum Conversion {
    case getCurrencies
    case getConversionRate(from: String, to: String)
}

extension Conversion {
    static let apiKey: String = "63bb6caabea441e2a41b6a3f"
}

extension Conversion: TargetType {
    
    var baseURL: URL {
        URL(string: "https://v6.exchangerate-api.com/v6/\(Conversion.apiKey)/")!
    }
    
    var path: String {
        switch self {
        case .getCurrencies:
            "codes"
        case let .getConversionRate(from, to):
            "pair/\(from)/\(to)/"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        nil
    }
}

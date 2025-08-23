//
//  Provider.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import Moya

struct Provider {
    
    static let conversionProvider = MoyaProvider<Conversion>(
        plugins: [
            NetworkLoggerPlugin(
                configuration: .init(
                    logOptions: [
                        .requestBody,
                        .successResponseBody,
                        .errorResponseBody
                    ]
                )
            )
        ]
    )
}

enum MoyaError: Error {
    case requestError
    case parseError
}

extension MoyaProvider {
    
    @discardableResult
    func request<T: Decodable>(
        _ target: Target,
        _ type: T.Type,
        onSuccess: @escaping (T) -> Void = { _ in },
        onError: @escaping (MoyaError) -> Void = { _ in }
    ) -> Cancellable {
        
        return request(target, completion: { result in
            switch result {
            case let .success(response):
                do {
                    let result = try response.map(T.self)
                    onSuccess(result)
                } catch {
                    onError(MoyaError.parseError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                onError(MoyaError.requestError)
            }
        })
    }
}

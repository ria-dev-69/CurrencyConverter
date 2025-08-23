//
//  WithableProtocol.swift
//  CurrencyConverter
//
//  Created by Irina on 14.08.2025.
//

import Foundation

protocol WithableProtocol {
    
    associatedtype T
    
    @discardableResult func with(_ closure: (_ instance: T) -> Void) -> T
}

extension WithableProtocol {
    
    @discardableResult func with(_ closure: (_ instance: Self) -> Void) -> Self {
        closure(self)
        
        return self
    }
}

extension NSObject: WithableProtocol { }

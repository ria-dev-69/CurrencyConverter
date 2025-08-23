//
//  TextFieldWithEdgeInsets.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

class TextFieldWithEdgeInsets: UITextField {
    
    var edgeInsets = UIEdgeInsets(
        top: 12,
        left: 12,
        bottom: 12,
        right: 12
    )
    
    override func textRect(
        forBounds bounds: CGRect
    ) -> CGRect {
        
        super.textRect(forBounds: bounds).inset(by: edgeInsets)
    }
    
    override func editingRect(
        forBounds bounds: CGRect
    ) -> CGRect {
        
        super.editingRect(forBounds: bounds).inset(by: edgeInsets)
    }
}

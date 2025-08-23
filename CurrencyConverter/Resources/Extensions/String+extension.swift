//
//  String+extension.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

extension String {
    
    func makeAttributedString(
        font: UIFont = UIFont.semibold(16),
        textcolor: UIColor = .baseWhite,
        alignment: NSTextAlignment = .center
    ) -> NSAttributedString {
        let style = NSMutableParagraphStyle().with({
            $0.alignment = alignment
        })
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textcolor,
            .paragraphStyle: style
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}

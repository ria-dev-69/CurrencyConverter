//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    private let currencyNameLabel = UILabel().with({
        $0.font = .regular(16)
        $0.textColor = .baseWhite
    })
    
    private let currencyCodeLabel = UILabel().with({
        $0.font = .medium(14)
        $0.textColor = .baseGray
        $0.textAlignment = .center
    })
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(currencyCodeLabel)
        
        currencyNameLabel.snp.makeConstraints({
            $0.leading.equalTo(Device.baseInset)
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.trailing.equalTo(currencyCodeLabel.snp.leading).offset(-8)
        })
        
        currencyCodeLabel.snp.makeConstraints({
            $0.trailing.equalTo(-Device.baseInset)
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalTo(Device.isIpad ? 70 : 50)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrencyCell {
    
    func configure(
        currency: Currency
    ) {
        currencyNameLabel.text = currency.currencyName
        currencyCodeLabel.text = currency.currencyCode
    }
}

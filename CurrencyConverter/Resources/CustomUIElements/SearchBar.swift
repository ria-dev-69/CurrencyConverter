//
//  SearchBar.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

class SearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension SearchBar {
    
    func setup() {
        barTintColor = .baseWhite.withAlphaComponent(0.1)
        setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        setPositionAdjustment(UIOffset(horizontal: 12, vertical: 0), for: .search)
        setPositionAdjustment(UIOffset(horizontal: -6, vertical: 0), for: .clear)
        setImage(.searchBarIcon.imageFlippedForRightToLeftLayoutDirection(), for: .search, state: .normal)
        setImage(.searchBarCross, for: .clear, state: .normal)
        searchTextPositionAdjustment.horizontal = 4
        
        let searchField = value(forKey: "searchField") as? UITextField
        if let textField = searchField {
            textField.textColor = .baseWhite
            textField.font = .medium(16)
            textField.clipsToBounds = true
            textField.backgroundColor = .baseWhite.withAlphaComponent(0.1)
            textField.leftView?.tintColor = UIColor.baseWhite
            
            textField.snp.makeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.height.equalTo(Device.isIpad ? 60 : 40)
            })
        }
        
        setPlaceholder("Search")
    }
}

extension SearchBar {
    
    func setPlaceholder(_ text: String) {
        let searchField = value(forKey: "searchField") as? UITextField
        searchField?.attributedPlaceholder = NSAttributedString.init(
            string: text,
            attributes: [
                .foregroundColor: UIColor.baseWhite.withAlphaComponent(0.5)
            ]
        )
    }
}

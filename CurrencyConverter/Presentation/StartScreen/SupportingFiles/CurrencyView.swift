//
//  CurrencyView.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

class CurrencyView: UIView {
    
    private let currencyAmountTextField = TextFieldWithEdgeInsets().with({
        $0.font = .medium(16)
        $0.textColor = .baseWhite
        $0.backgroundColor = .baseWhite.withAlphaComponent(0.1)
        $0.setBorder(color: .baseGray)
        $0.isUserInteractionEnabled = false
        $0.keyboardType = .decimalPad
        $0.keyboardAppearance = .dark
    })
    
    private lazy var chooseCurrencyButton = UIButton().with({
        $0.backgroundColor = .baseWhite.withAlphaComponent(0.1)
        $0.setBorder(color: .baseGray)
        $0.applyBlurEffect()
        $0.setAttributedTitle("?".makeAttributedString(), for: .normal)
        $0.setAction(chooseCurrencyButtonAction)
    })
    
    private var didTapChooseCurrencyButton: (() -> Void)?
    private var shouldChangeText: ((_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool)?
    private var textDidChange: ((String?) -> Void)?
    
    init(
        didTapChooseCurrencyButton: (() -> Void)?,
        shouldChangeText: ((_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool)? = nil,
        textDidChange: ((String?) -> Void)? = nil
    ) {
        super.init(frame: .zero)
        self.didTapChooseCurrencyButton = didTapChooseCurrencyButton
        self.shouldChangeText = shouldChangeText
        self.textDidChange = textDidChange
        
        addSubview(currencyAmountTextField)
        addSubview(chooseCurrencyButton)
        
        currencyAmountTextField.snp.makeConstraints({
            $0.verticalEdges.leading.equalToSuperview()
            $0.trailing.equalTo(chooseCurrencyButton.snp.leading).offset(1)
        })
        
        chooseCurrencyButton.snp.makeConstraints({
            $0.verticalEdges.trailing.equalToSuperview()
            $0.size.equalTo(Device.isIpad ? 70 : 50)
        })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func chooseCurrencyButtonAction() {
        didTapChooseCurrencyButton?()
    }
}

extension CurrencyView {
    
    func setTextFieldEditable() {
        currencyAmountTextField.isUserInteractionEnabled = true
        currencyAmountTextField.delegate = self
    }
    
    func set(placeholder: String) {
        currencyAmountTextField.attributedPlaceholder = placeholder.makeAttributedString(textcolor: .baseWhite.withAlphaComponent(0.5), alignment: .natural)
    }
    
    func set(currencyButtonTitle: String) {
        chooseCurrencyButton.setAttributedTitle(currencyButtonTitle.makeAttributedString(), for: .normal)
    }
    
    func set(amount: Double) {
        currencyAmountTextField.text = amount > 0 ? String(format: "%.2f", amount) : ""
    }
}

//MARK: - UITextFieldDelegate
extension CurrencyView: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        shouldChangeText?(textField, range, string) ?? false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textDidChange?(textField.text)
    }
}

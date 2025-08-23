//
//  StartScreenViewController.swift
//  CurrencyConverter
//
//  Created by Irina on 14.08.2025.
//

import UIKit
import SnapKit

protocol StartScreenViewControllerEvents {
    func viewDidLoad()
    func didTapReverse()
    func didTapChooseCurrencyButton(currencyType: CurrencyType)
    func shouldChangeText(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool
    func textDidChange(text: String?)
}

class StartScreenViewController: UIViewController {
    
    private let backImageView = UIImageView().with({
        $0.image = .startScreenBack
    })
    
    private let currenciesStackView = UIStackView().with({
        $0.spacing = 40
        $0.distribution = .fillEqually
    })
    
    private lazy var fromCurrencyView = CurrencyView(
        didTapChooseCurrencyButton: { [weak self] in
            self?.presenter?.didTapChooseCurrencyButton(currencyType: .from)
        }, shouldChangeText: { [weak self] textField, range, string in
            guard let self else { return false }
            
            return presenter?.shouldChangeText(textField, range, string) ?? false
        }, textDidChange: { [weak self] text in
            guard let self else { return }
            
            presenter?.textDidChange(text: text)
        }).with({
            $0.setTextFieldEditable()
            $0.set(placeholder: "Amount")
        })
    
    private lazy var toCurrencyView = CurrencyView(didTapChooseCurrencyButton: { [weak self] in
        self?.presenter?.didTapChooseCurrencyButton(currencyType: .to)
    }).with({
        $0.set(placeholder: "Result")
    })
    
    private let equalSignLabel = UILabel().with({
        $0.text = "="
        $0.textColor = .baseWhite
        $0.font = .semibold(20)
        $0.textAlignment = .center
    })
    
    private let equalityIndicator = UIActivityIndicatorView().with({
        $0.color = .white.withAlphaComponent(0.3)
        $0.alpha = 0
    })
    
    private let loadingIndicator = UIActivityIndicatorView().with({
        $0.color = .white
        $0.style = .large
    })
    
    var presenter: StartScreenViewControllerEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupViewElements()
        makeConstraints()
    }
}

private extension StartScreenViewController {
    func addSubviews() {
        view.addSubview(backImageView)
        view.addSubview(currenciesStackView)
        currenciesStackView.addArrangedSubview(fromCurrencyView)
        currenciesStackView.addArrangedSubview(toCurrencyView)
        currenciesStackView.addSubview(equalSignLabel)
        currenciesStackView.addSubview(equalityIndicator)
        view.addSubview(loadingIndicator)
    }
    
    func setupViewElements() {
        title = "Currency converter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .startScreenReverse,
            style: .plain,
            target: self,
            action: #selector(reverseButtonAction)
        )
        view.isUserInteractionEnabled = false
        loadingIndicator.startAnimating()
    }
    
    func makeConstraints() {
        backImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        currenciesStackView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Device.baseInset)
            $0.horizontalEdges.equalToSuperview().inset(Device.baseInset)
        })
        
        equalSignLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        equalityIndicator.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        loadingIndicator.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
}

private extension StartScreenViewController {
    @objc func reverseButtonAction() {
        presenter?.didTapReverse()
    }
}

//MARK: - StartScreenPresenterOutput
extension StartScreenViewController: StartScreenPresenterOutput {
    
    func hideLoader(isUserInteractionEnabled: Bool) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.loadingIndicator.alpha = 0
        }, completion: { [weak self] _ in
            guard let self else { return }
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            view.isUserInteractionEnabled = isUserInteractionEnabled
        })
    }
    
    func animateEqualityIndicator(needShow: Bool) {
        if needShow {
            equalSignLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.equalityIndicator.alpha = needShow ? 1 : 0
        }, completion: { [weak self] _ in
            needShow ? self?.equalityIndicator.startAnimating() : self?.equalityIndicator.stopAnimating()
            if !needShow {
                self?.equalSignLabel.isHidden = false
            }
        })
    }
    
    func updateView(fromCurrency: String, toCurrency: String) {
        fromCurrencyView.set(currencyButtonTitle: fromCurrency)
        toCurrencyView.set(currencyButtonTitle: toCurrency)
    }
    
    func updateView(result: Double) {
        toCurrencyView.set(amount: result)
    }
}

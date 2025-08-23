//
//  CurrenciesListViewController.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit
import SnapKit

protocol CurrenciesListViewControllerEvents {
    func didTapCross()
    func didSelect(currency: Currency)
    func didUpdate(searchText: String)
}

class CurrenciesListViewController: UIViewController {
    
    private let backImageView = UIImageView().with({
        $0.image = .currenciesListBack
    })
    
    private lazy var crossButton = UIButton().with({
        $0.setImage(.currenciesListCross, for: .normal)
        $0.setInsets(10)
        $0.setAction(crossButtonAction)
    })
    
    private lazy var titleView = UILabel().with({
        $0.font = .semibold(18)
        $0.textColor = .baseWhite
        $0.textAlignment = .center
    })
    
    private lazy var searchBar = SearchBar().with({
        $0.delegate = self
        $0.keyboardAppearance = .dark
        $0.keyboardType = .alphabet
    })
    
    private lazy var currenciesTableView = UITableView().with({
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.contentInset.bottom = Device.baseInset
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
    })
    
    private var currencies = [Currency]()
    
    var presenter: CurrenciesListViewControllerEvents?
    
    init(
        currencies: [Currency],
        currencyType: CurrencyType
    ) {
        super.init(nibName: nil, bundle: nil)
        self.currencies = currencies
        titleView.text = "Choose '\(currencyType)' currency"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        addObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

private extension CurrenciesListViewController {
    
    func addSubviews() {
        view.addSubview(backImageView)
        view.addSubview(crossButton)
        view.addSubview(titleView)
        view.addSubview(searchBar)
        view.addSubview(currenciesTableView)
    }
    
    func makeConstraints() {
        backImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        crossButton.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.size.equalTo(40)
        })
        
        titleView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(crossButton.snp.centerY)
        })
        
        searchBar.snp.makeConstraints({
            $0.top.equalTo(crossButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(Device.baseInset)
        })
        
        currenciesTableView.snp.makeConstraints({
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

private extension CurrenciesListViewController {
    
    @objc func crossButtonAction() {
        presenter?.didTapCross()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height ?? 0
        
        currenciesTableView.contentInset.bottom = Device.baseInset + keyboardHeight
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        currenciesTableView.contentInset.bottom = Device.baseInset
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - UITableViewDataSource
extension CurrenciesListViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        currencies.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = currenciesTableView.dequeueReusableCell(withIdentifier: "CurrencyCell")
        guard let currentCell = cell as? CurrencyCell else {
            return UITableViewCell()
        }
        
        currentCell.configure(currency: currencies[indexPath.row])
        
        return currentCell
    }
}

//MARK: - UITableViewDelegate
extension CurrenciesListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter?.didSelect(currency: currencies[indexPath.row])
    }
}

//MARK: - UISearchBarDelegate
extension CurrenciesListViewController: UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        presenter?.didUpdate(searchText: searchText)
    }
}

//MARK: - CurrenciesListPresenterOutput
extension CurrenciesListViewController: CurrenciesListPresenterOutput {
    
    func updateView(currencies: [Currency]) {
        self.currencies = currencies
        currenciesTableView.reloadData()
    }
}

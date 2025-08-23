//
//  AlertProtocol.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

protocol AlertProtocol {
    func presentAlert(
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [AlertAction]
    )
    
    var navigationController: NavigationController { get }
}

extension AlertProtocol {
    
    func presentAlert(
        title: String? = nil,
        message: String? = nil,
        style: UIAlertController.Style = .alert,
        actions: [AlertAction]
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        
        if Device.isIpad, let popover = alert.popoverPresentationController {
            guard let view = navigationController.view else { return }
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        actions.forEach({
            alert.addAction($0.alertAction)
        })
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}

struct AlertAction {
    let title: String?
    let preferedStyle: UIAlertAction.Style
    let handler: ((UIAlertAction) -> Void)?
    
    var alertAction: UIAlertAction {
        UIAlertAction(
            title: title,
            style: preferedStyle,
            handler: handler
        )
    }
    
    static var okAction: Self {
        .init(
            title: "OK",
            preferedStyle: .default,
            handler: nil
        )
    }
}

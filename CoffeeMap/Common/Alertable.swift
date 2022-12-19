//
//  Alertable.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

public protocol Alertable {}

public extension Alertable where Self: UIViewController {
    func showAlert(title: String = "",
                   message: String,
                   preferredStyle: UIAlertController.Style = .alert,
                   completion: (()-> Void)? = nil) {

        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okButton: UIAlertAction = UIAlertAction(title: CommonString.ok.text, style: .default)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: completion)
    }
}

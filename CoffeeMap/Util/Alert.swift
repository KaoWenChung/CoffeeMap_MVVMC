//
//  Alert.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

class Alert {
    /// It's a simple alert which only show title, message, and a button "OK"
    static func show(vc aVC: UIViewController,
                            title aTitle: String? = nil,
                            message aMessage: String? = nil) {
        let _alertController: UIAlertController = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .alert)
        let _cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        _alertController.addAction(_cancelAction)
        aVC.present(_alertController, animated: true, completion: nil)
    }

}


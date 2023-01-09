//
//  Spinner.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit
// Used Singleton to implement a Loading view
final class Spinner {
    static let shared = Spinner()
    private init() {}
    
    var spinner: UIActivityIndicatorView?

    func showOn(_ view: UIView) {
        hide()
        spinner = UIActivityIndicatorView()
        spinner!.style = .medium
        spinner!.hidesWhenStopped = true
        view.addSubview(spinner!)

        spinner!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner!.centerYAnchor.constraint(equalTo: view.centerYAnchor), spinner!.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        spinner!.startAnimating()
    }

    func hide() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
    }
}

//
//  Spinner.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

class Spinner {
    static let shared = Spinner()
    private init() {}
    
    var spinner: UIActivityIndicatorView?

    func showOn(_ view: UIView) {
        hide()
        spinner = UIActivityIndicatorView()
        spinner!.style = .medium
        spinner!.hidesWhenStopped = true
        view.addSubview(spinner!)
        
        // Define the constraint of spinner
        spinner!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner!.centerYAnchor.constraint(equalTo: view.centerYAnchor), spinner!.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // Start animation
        spinner!.startAnimating()
    }

    func hide() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
    }
}

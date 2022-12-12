//
//  BaseViewController.swift
//  CoffeeMap
//
//  Created by wyn on 2022/9/25.
//

import UIKit

class BaseViewController: UIViewController {

    func open(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async  {
            viewController.hidesBottomBarWhenPushed = true
            viewController.modalPresentationStyle = .fullScreen
            if let _navigationController: UINavigationController = self.navigationController {
                _navigationController.pushViewController(viewController, animated: animated)
                completion?()
            } else {
                self.present(viewController, animated: animated, completion: completion)
            }
        }
    }

}

//
//  UIView.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/5.
//

import UIKit

extension UIView {
    var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

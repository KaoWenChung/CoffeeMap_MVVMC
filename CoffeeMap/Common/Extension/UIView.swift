//
//  UIView.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/5.
//

import UIKit

extension UIView {
    /// Use for register UICollectionView or UITableView
    static var name: String {
        return String(describing: self)
    }

    var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

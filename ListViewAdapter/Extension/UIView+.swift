//
//  UIView+.swift
//  ListViewAdapter
//
//  Created by wyn on 2024/6/24.
//

import UIKit

extension UIView {
    /// Use for register UICollectionView or UITableView
    static var name: String {
        return String(describing: self)
    }
}

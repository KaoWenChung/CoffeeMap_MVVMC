//
//  TableCollectionViewAdapterDelegate.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

public protocol TableCollectionViewAdapterDelegate: AnyObject {
    /// Apply model to view
    func configure(model: AdapterItemModel, view: UIView, indexPath: IndexPath)
    /// Handle view selection
    func select(model: AdapterItemModel)
    /// Size the view
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize
}

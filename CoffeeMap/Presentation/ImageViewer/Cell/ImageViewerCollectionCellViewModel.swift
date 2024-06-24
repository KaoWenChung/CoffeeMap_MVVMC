//
//  ImageViewerConllectionViewCell.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/18.
//

import UIKit
import ListViewAdapter

struct ImageViewerCollectionCellViewModel: AdapterItemModel {
    var type: UIView.Type { ImageViewerCollectionViewCell.self }
    let imageURL: String
}

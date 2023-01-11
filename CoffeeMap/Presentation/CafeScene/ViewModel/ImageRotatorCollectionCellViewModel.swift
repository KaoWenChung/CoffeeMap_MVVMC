//
//  ImageRotatorCollectionCellViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/11.
//

import UIKit

struct ImageRotatorCollectionCellViewModel: AdapterItemModel {
    var type: UIView.Type { return ImageRotatorCollectionViewCell.self }
    let prefix: String?
    let suffix: String?
    let date: String?
    init(_ photoModel: CafePhotoModel) {
        prefix = photoModel.prefix
        suffix = photoModel.suffix
        if let createdAt = photoModel.createdAt {
            let date = createdAt.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            let dateString = date?.toString(dateFormat: "yyyy-MM-dd")
            self.date = dateString
        } else {
            date = nil
        }
    }
}

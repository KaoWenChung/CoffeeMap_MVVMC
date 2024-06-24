//
//  PlaceSearchCellModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit
import ListViewAdapter

struct CafeListModel {
    let cursor: String?
    let cafeList: [CafeTableViewCellModel]
}

struct CafeTableViewCellModel: AdapterItemModel {
    enum CafeListTableViewCellString: LocallizedStringType {
        case meters
    }
    enum Content {
        static let imageSize: String = "64"
    }
    var type: UIView.Type { return CafeTableViewCell.self }
    let name: String
    let address: String
    let distance: String?
    let iconURL: String?
    let description: String?
    let coordinate: (latitude: Double, longitude: Double)?
    let photos: [CafePhotoModel]

    init(_ cafe: Cafe, photoModel: [CafePhotoModel]) {
        name = cafe.name ?? ""
        if let address = cafe.formattedAddress,
           !address.isEmpty {
            self.address = address
        } else {
            address = "-"
        }
        if let distance = cafe.distance {
            self.distance = distance.description + CafeListTableViewCellString.meters.text
        } else {
            distance = nil
        }
        if let latitude = cafe.latitude,
           let longitude = cafe.longitude {
            self.coordinate = (latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
        if let photo = photoModel.first,
           let prefix = photo.prefix,
           let suffix = photo.suffix {
            iconURL = prefix + Content.imageSize + suffix
        } else {
            iconURL = nil
        }
        self.photos = photoModel
        self.description = cafe.description
    }
}

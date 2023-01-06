//
//  PlaceSearchCellModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

struct CafeListModel {
    let cursor: String?
    let cafeList: [CafeTableViewCellModel]
}

struct CafeTableViewCellModel: AdapterItemModel {
    enum CafeListTableViewCellString: LocallizedStringType {
        case meters
    }
    var type: UIView.Type { return CafeTableViewCell.self }
    let name: String
    let address: String
    let distance: String?
    let iconURL: String?
    let coordinate: (latitude: Double, longitude: Double)?
    let photo: [CafePhotoModel]
    
    init(_ dataModel: CafePlaceResponseDTO.GetPlaceResultsDTO, photoModel: [CafePhotoModel]) {
        name = dataModel.name ?? ""
        if let location = dataModel.location,
           let address = location.formattedAddress,
           !address.isEmpty {
            self.address = address
        } else {
            address = "-"
        }
        if let distance = dataModel.distance {
            self.distance = distance.description + CafeListTableViewCellString.meters.text
        } else {
            distance = nil
        }
        if let geocodes = dataModel.geocodes,
           let coordinate = geocodes.main,
           let latitude = coordinate.latitude,
           let longitude = coordinate.longitude {
            self.coordinate = (latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
        if let photo = photoModel.first,
           let prefix = photo.prefix,
           let suffix = photo.suffix {
            iconURL = prefix + "64" + suffix
        } else {
            iconURL = nil
        }
        self.photo = photoModel
    }
}

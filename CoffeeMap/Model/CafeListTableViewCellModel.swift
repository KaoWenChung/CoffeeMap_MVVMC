//
//  PlaceSearchCellModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

struct CafeListTableViewCellModel: AdapterItemModel {
    enum CafeListTableViewCellString: LocallizedStringType {
        case meters
    }
    var type: UIView.Type { return CafeListTableViewCell.self }
    let name: String
    let address: String
    let distance: String?
    let iconURL: String?
    let coordinate: (latitude: Double, longitude: Double)?
    
    init(_ dataModel: CafePlaceResponseDTO.GetPlaceResultsDTO) {
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
        if let category = dataModel.categories?.first,
           let icon = category.icon,
           let prefix = icon.prefix,
           let suffix = icon.suffix {
            iconURL = prefix + "64" + suffix
        } else {
            iconURL = nil
        }
    }
}

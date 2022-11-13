//
//  PlaceSearchCellModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

struct CafeListTableViewCellModel: AdapterItemModel {
    var type: UIView.Type { return CafeListTableViewCell.self }
    let name: String
    let address: String
    let distance: String?
    let coordinate: (latitude: Double, longitude: Double)?
    
    init(_ dataModel: GetPlaceResponseDTO.GetPlaceResultsDTO) {
        name = dataModel.name ?? ""
        if let location = dataModel.location,
           let address = location.formattedAddress,
           !address.isEmpty {
            self.address = address
        } else {
            address = "-"
        }
        if let distance = dataModel.distance {
            self.distance = distance.description + " meters"
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
    }

}

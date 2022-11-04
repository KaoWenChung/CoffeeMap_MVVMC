//
//  PlaceDetailViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2022/9/25.
//

class PlaceDetailViewModel {

    let name: String
    let coordinate: (latitude: Double, longitude: Double)?
    let address: String

    init(_ rowModel: PlaceSearchTableViewCellRowModel) {
        name = rowModel.name
        self.coordinate = rowModel.coordinate
        address = rowModel.address
    }
}

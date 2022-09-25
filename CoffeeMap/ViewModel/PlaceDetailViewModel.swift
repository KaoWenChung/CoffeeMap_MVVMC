//
//  PlaceDetailViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2022/9/25.
//

class PlaceDetailViewModel {

    let coordinate: String?
    let address: String

    init(_ rowModel: PlaceSearchTableViewCellRowModel) {

        self.coordinate = rowModel.coordinate
        address = rowModel.address

    }
}

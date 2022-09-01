//
//  PlaceSearchViewViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

class PlaceSearchViewModel: BaseViewModel {

    private(set) var placeList: [PlaceSearchCellViewModel] = []
    let apiService: FoursquareRepositoryDelegate

    init(_ apiService: FoursquareRepositoryDelegate) {
        self.apiService = apiService
    }

}

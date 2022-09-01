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

    func getPlaceListBy(_ dataModel: GetPlaceResponseModel) -> [PlaceSearchCellViewModel] {
        var result: [PlaceSearchCellViewModel] = []
        for item in dataModel.results ?? [] {
            result.append(PlaceSearchCellViewModel(item))
        }
        return result
    }
}

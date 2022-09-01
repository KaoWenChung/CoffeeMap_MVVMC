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

    func fetchData(ll: String, completion: Completion? = nil) {
        let param: GetPlaceParamModel = GetPlaceParamModel(ll: ll, radius: 200, query: "coffee")
        apiService.getPlace(param: param) { (result: Result<GetPlaceResponseModel>) in
            switch result {
            case .success(let aValue):
                self.placeList = self.getPlaceListBy(aValue)
                completion?(.success)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func getPlaceListBy(_ dataModel: GetPlaceResponseModel) -> [PlaceSearchCellViewModel] {
        var result: [PlaceSearchCellViewModel] = []
        for item in dataModel.results ?? [] {
            result.append(PlaceSearchCellViewModel(item))
        }
        return result
    }
}

//
//  PlaceSearchViewViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

final class PlaceSearchViewModel: BaseViewModel {

    private(set) var placeList: [PlaceSearchTableViewCellRowModel] = []
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

    func getPlaceListBy(_ dataModel: GetPlaceResponseModel) -> [PlaceSearchTableViewCellRowModel] {
        var result: [PlaceSearchTableViewCellRowModel] = []
        for item in dataModel.results ?? [] {
            result.append(PlaceSearchTableViewCellRowModel(item))
        }
        return result
    }
}

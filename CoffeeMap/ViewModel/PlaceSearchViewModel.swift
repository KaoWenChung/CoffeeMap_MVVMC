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
            case .success(let value):
                let getPlaceResults = self.getSortedGetPlaceResult(value)
                self.placeList = self.getPlaceListBy(getPlaceResults)
                completion?(.success)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func getSortedGetPlaceResult(_ dataModel: GetPlaceResponseModel) -> [GetPlaceResultModel] {
        guard let results = dataModel.results, !results.isEmpty else { return [] }
        let sortedData = results.sorted(by: { ($0.distance ?? 0) < ($1.distance ?? 0) })
        return sortedData
    }

    func getPlaceListBy(_ dataModel: [GetPlaceResultModel]) -> [PlaceSearchTableViewCellRowModel] {
        var result: [PlaceSearchTableViewCellRowModel] = []
        for item in dataModel {
            result.append(PlaceSearchTableViewCellRowModel(item))
        }
        return result
    }

}

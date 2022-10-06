//
//  PlaceSearchViewViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

final class PlaceSearchViewModel: BaseViewModel {

    private(set) var placeList: [AdapterSectionModel] = []
    let apiService: FoursquareRepositoryDelegate

    init(_ apiService: FoursquareRepositoryDelegate) {
        self.apiService = apiService
    }

    func fetchData(coordinate: String, completion: Completion?) {
        let param: GetPlaceParamModel = GetPlaceParamModel(ll: coordinate, radius: 200, query: "coffee")
        apiService.getPlace(param: param) { result in
            switch result {
            case .success(let value):
                if let results = value.results {
                    self.placeList = [AdapterSectionModel(items: self.getPlaceListBy(results))]
                }
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

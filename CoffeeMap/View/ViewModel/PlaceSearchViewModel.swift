//
//  PlaceSearchViewViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

final class PlaceSearchViewModel: BaseViewModel {

    private(set) var placeList: [AdapterSectionModel] = []
    let apiService: CafePlacesRepositoryType

    init(_ apiService: CafePlacesRepositoryType) {
        self.apiService = apiService
    }

    func fetchData(coordinate: String) async throws {
        let param: GetPlaceParamModel = GetPlaceParamModel(ll: coordinate, radius: 200, query: "coffee")
        let data = try await apiService.getPlace(param: param)
        if let results = data.results {
            placeList = [AdapterSectionModel(items: getPlaceListBy(results))]
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

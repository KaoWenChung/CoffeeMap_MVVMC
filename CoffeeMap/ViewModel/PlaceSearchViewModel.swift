//
//  PlaceSearchViewViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

final class PlaceSearchViewModel {

    private(set) var placeList: [PlaceSearchTableViewCellRowModel] = []
    let apiService: FoursquareRepositoryDelegate

    init(_ apiService: FoursquareRepositoryDelegate) {
        self.apiService = apiService
    }

    func fetchData(ll: String, completion: ((Result<GetPlaceResponseModel>) -> Void)?) {
        let param: GetPlaceParamModel = GetPlaceParamModel(ll: ll, radius: 200, query: "coffee")
        apiService.getPlace(param: param, completion: completion)
    }

    func getSortedGetPlaceResult(_ dataModel: GetPlaceResponseModel) -> [GetPlaceResultModel] {
        guard let results = dataModel.results, !results.isEmpty else { return [] }
        let sortedData = results.sorted(by: { ($0.distance ?? 0) < ($1.distance ?? 0) })
        return sortedData
    }

    func getPlaceListBy(_ dataModel: [GetPlaceResultModel], cellAction: ((BaseCellRowModel) -> ())?){
        var result: [PlaceSearchTableViewCellRowModel] = []
        for item in dataModel {
            result.append(PlaceSearchTableViewCellRowModel(item, action: cellAction))
        }
        placeList = result
    }

}

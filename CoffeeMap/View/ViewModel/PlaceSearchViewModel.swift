//
//  PlaceSearchViewViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

final class PlaceSearchViewModel: BaseViewModel {

    private let searchCafeUseCase: SearchCafeUseCaseType
    private(set) var placeList: [AdapterSectionModel] = []

    private var cafesLoadTask: CancellableType? { willSet { cafesLoadTask?.cancel() } }
    
    init(searchCafeUseCase: SearchCafeUseCaseType) {
        self.searchCafeUseCase = searchCafeUseCase
    }

    func loadData(cafeQuery: CofeRequestDTO) {
        cafesLoadTask = searchCafeUseCase.execute(request: cafeQuery) { result in
            switch result {
            case .success(let value):
                if let results = value.results {
                    self.placeList = [AdapterSectionModel(items: self.getPlaceListBy(results))]
                }
            case .failure(let error):
                print(error)
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

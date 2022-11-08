//
//  PlaceSearchDIContainer.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/4.
//

import Foundation

final class PlaceSearchDIContainer {

    struct Dependencies {
        let dataTransferService: DataTransferServiceType
    }
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - UseCase
    func makeSearchCafeUseCase() -> SearchCafeUseCaseType {
        return SearchCafeUseCase(cafeRepository: makeCafePlacesRepository())
    }

    // MARK: - Repositories
    func makeCafePlacesRepository() -> CafePlacesRepository2Type {
        return CafePlacesRepository2(dataTransferService: dependencies.dataTransferService)
    }

    // MARK: - Cafe Place List
    func makeCafeListViewController() -> PlaceSearchViewController {
        return PlaceSearchViewController(makeCafeListViewModel())
    }
    
    func makeCafeListViewModel() -> PlaceSearchViewModel {
        return PlaceSearchViewModel(searchCafeUseCase: makeSearchCafeUseCase())
    }
    
}

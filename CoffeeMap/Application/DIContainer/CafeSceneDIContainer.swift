//
//  CafeSceneDIContainer.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/4.
//

import UIKit

final class CafeSceneDIContainer {

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
    func makeCafeListViewController() -> CafeListViewController {
        return CafeListViewController(makeCafeListViewModel())
    }
    
    func makeCafeListViewModel() -> CafeListViewModel {
        return CafeListViewModel(searchCafeUseCase: makeSearchCafeUseCase())
    }

    // MARK: - Flow Coordinators
    func makeCafeSearchFlowCoordinator(navigationController: UINavigationController) -> CafeSearchFlowCoordinator {
        
        return CafeSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension CafeSceneDIContainer: CafeSearchFlowCoordinatorDependenciesType {}

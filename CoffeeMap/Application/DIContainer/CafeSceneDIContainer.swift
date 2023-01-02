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
        let imageDataTransferService: DataTransferServiceType
        let imageCache: ImageCacheType
    }
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - UseCase
    func makeSearchCafeListUseCase() -> SearchCafeListUseCaseType {
        return SearchCafeListUseCase(cafeRepository: makeCafePlacesRepository())
    }

    // MARK: - Repositories
    func makeCafePlacesRepository() -> CafePlacesRepositoryType {
        return CafePlacesRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func makeImagesRepository() -> ImageRepositoryType {
        return ImageRepository(dataTransferService: dependencies.imageDataTransferService, imageCache: dependencies.imageCache)
    }

    // MARK: - Cafe Place List
    func makeCafeListViewController(actions: CafeListViewModelActions?) -> CafeListViewController {
        return CafeListViewController(makeCafeListViewModel(actions: actions), imageRepository: makeImagesRepository())
    }
    
    func makeCafeListViewModel(actions: CafeListViewModelActions?) -> CafeListViewModel {
        return CafeListViewModel(searchCafeUseCase: makeSearchCafeListUseCase(), actions: actions)
    }

    // MARK: - Flow Coordinators
    func makeCafeSearchFlowCoordinator(navigationController: UINavigationController) -> CafeSearchFlowCoordinator {
        
        return CafeSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension CafeSceneDIContainer: CafeSearchFlowCoordinatorDependenciesType {}

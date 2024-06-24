//
//  CafeSceneDIContainer.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/4.
//

import UIKit
import Networking

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
        return ImageRepository(dataTransferService: dependencies.imageDataTransferService,
                               imageCache: dependencies.imageCache)
    }

    // MARK: - Cafe Place List
    func makeCafeListViewController(actions: CafeListViewModelActions?) -> CafeListViewController {
        return CafeListViewController(makeCafeListViewModel(actions: actions),
                                      imageRepository: makeImagesRepository())
    }

    func makeCafeListViewModel(actions: CafeListViewModelActions?) -> CafeListViewModel {
        return CafeListViewModel(searchCafeUseCase: makeSearchCafeListUseCase(),
                                 actions: actions)
    }

    // MARK: - Cafe Detail
    func makeCafeDetailViewController(cellModel: CafeTableViewCellModel,
                                      actions: CafeDetailViewModelActions) -> CafeDetailViewController {
        let viewModel = makeCafeDetailViewModel(cellModel: cellModel, actions: actions)
        return CafeDetailViewController(viewModel, imageRepository: makeImagesRepository())
    }

    func makeCafeDetailViewModel(cellModel: CafeTableViewCellModel,
                                 actions: CafeDetailViewModelActions) -> CafeDetailViewModel {
        return CafeDetailViewModel(cellModel, actions: actions)
    }

    // MARK: Image Viewer
    func makeImageViewerViewController(_ viewModel: ImageRotatorViewModel) -> ImageViewerViewController {
        ImageViewerViewController(viewModel: makeImageViewerViewModel(viewModel),
                                  imageRepository: makeImagesRepository())
    }

    func makeImageViewerViewModel(_ viewModel: ImageRotatorViewModel) -> ImageViewerViewModel {
        ImageViewerViewModel(imageRotatorCells: viewModel.imageCells,
                             page: viewModel.page, pastImageRect: nil)
    }

    // MARK: - Flow Coordinators
    func makeCafeSearchFlowCoordinator(navigationController: UINavigationController) -> CafeSearchFlowCoordinator {
        CafeSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension CafeSceneDIContainer: CafeSearchFlowCoordinatorDependency {}

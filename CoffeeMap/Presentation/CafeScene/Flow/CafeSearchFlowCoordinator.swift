//
//  CafeSearchFlowCoordinator.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

import UIKit

protocol CafeSearchFlowCoordinatorDependency {
    func makeCafeListViewController(actions: CafeListViewModelActions?) -> CafeListViewController
    func makeCafeDetailViewController(cellModel: CafeTableViewCellModel,
                                      actions: CafeDetailViewModelActions) -> CafeDetailViewController
    func makeImageViewerViewController(_ viewModel: ImageRotatorViewModel) -> ImageViewerViewController
}

final class CafeSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: CafeSearchFlowCoordinatorDependency
    private weak var cafeListViewController: CafeListViewController?

    init(navigationController: UINavigationController,
         dependencies: CafeSearchFlowCoordinatorDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = CafeListViewModelActions(showCafeDetail: didSelectItem)
        let viewController = dependencies.makeCafeListViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: true)
        cafeListViewController = viewController
    }

    private func didSelectItem(_ item: CafeTableViewCellModel) {
        let actions = CafeDetailViewModelActions(showCafeRoute: didSelectRouter, didSelectImage: didSelectImage)
        let viewController = dependencies.makeCafeDetailViewController(cellModel: item, actions: actions)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func didSelectRouter(_ item: CafeTableViewCellModel) {
        let viewModel = CafeMapViewModel(item)
        // Dismiss CafeDetailViewController
        navigationController?.dismiss(animated: true)
        navigationController?.pushViewController(CafeMapViewController(viewModel), animated: false)
    }

    private func didSelectImage(_ viewModel: ImageRotatorViewModel) {
        let viewController = dependencies.makeImageViewerViewController(viewModel)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
}

//
//  CafeSearchFlowCoordinator.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

import UIKit

protocol CafeSearchFlowCoordinatorDependenciesType {
    func makeCafeListViewController(actions: CafeListViewModelActions?) -> CafeListViewController
    func makeCafeDetailViewController(cellModel: CafeTableViewCellModel, actions: CafeDetailViewModelActions) -> CafeDetailViewController
}

final class CafeSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: CafeSearchFlowCoordinatorDependenciesType
    
    private weak var cafeListViewController: CafeListViewController?

    init(navigationController: UINavigationController,
         dependencies: CafeSearchFlowCoordinatorDependenciesType) {
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
        let actions = CafeDetailViewModelActions(showCafeRoute: didSelectRouter)
        let viewController = dependencies.makeCafeDetailViewController(cellModel: item, actions: actions)
        navigationController?.present(viewController, animated: true)
    }

    private func didSelectRouter(_ item: CafeTableViewCellModel) {
        let viewModel = CafeMapViewModel(item)
        // Dismiss CafeDetailViewController
        navigationController?.dismiss(animated: true)
        navigationController?.pushViewController(CafeMapViewController(viewModel), animated: false)
    }
}

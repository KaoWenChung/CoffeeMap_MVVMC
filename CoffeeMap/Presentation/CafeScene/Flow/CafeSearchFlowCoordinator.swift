//
//  CafeSearchFlowCoordinator.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

import UIKit

protocol CafeSearchFlowCoordinatorDependenciesType {
    func makeCafeListViewController(actions: CafeListViewModelActions?) -> CafeListViewController
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
        let actions = CafeListViewModelActions(showCafeRoute: didSelectItem)
        let viewController = dependencies.makeCafeListViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: true)
        cafeListViewController = viewController
    }

    private func didSelectItem(_ item: CafeListTableViewCellModel) {
        let viewModel = CafeDetailViewModel(item)
        navigationController?.pushViewController(CafeDetailViewController(viewModel), animated: true)
    }
}

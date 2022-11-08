//
//  CafeSearchFlowCoordinator.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

import UIKit

protocol CafeSearchFlowCoordinatorDependenciesType {
    func makeCafeListViewController() -> PlaceSearchViewController
}

final class CafeSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: CafeSearchFlowCoordinatorDependenciesType
    
    private weak var cafeListViewController: PlaceSearchViewController?

    init(navigationController: UINavigationController? = nil,
         dependencies: CafeSearchFlowCoordinatorDependenciesType) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let viewController = dependencies.makeCafeListViewController()
        navigationController?.pushViewController(viewController, animated: true)
        cafeListViewController = viewController
    }
}


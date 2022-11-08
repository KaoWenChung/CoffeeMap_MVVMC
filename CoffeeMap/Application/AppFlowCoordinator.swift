//
//  AppFlowCoordinator.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App flow we can check wether user need to login, if so we go to Login flow
        let cafeSceneDIContainer = appDIContainer.makeCafeSceneDIContainer()
        let flow = cafeSceneDIContainer.makeCafeSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}

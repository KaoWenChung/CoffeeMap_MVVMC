//
//  AppDIContainer.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/4.
//

import Foundation

final class AppDIContainer {

    let appConfiguration = AppConfiguration()

    // MARK: - Network
    lazy var apiDataTransferService = {
        let config = APIDataNetworkConfigurable(baseURL: URL(string: self.appConfiguration.baseURL)!,
                                                headers: ["Authorization": self.appConfiguration.apiKey])
        let apiDataNetwork = NetworkService(config: config)
        return DataTransferService(networkService: apiDataNetwork)
    }()

    // MARK: - DIContainers of scenes
    func makeCafeSceneDIContainer() -> CafeSceneDIContainer {
        let dependencies = CafeSceneDIContainer.Dependencies(dataTransferService: apiDataTransferService)
        return CafeSceneDIContainer(dependencies: dependencies)
    }

}

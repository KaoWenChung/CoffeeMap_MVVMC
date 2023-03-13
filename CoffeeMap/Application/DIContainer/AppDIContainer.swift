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
        let config = APIDataNetworkConfigurable(baseURL: URL(string: appConfiguration.baseURL)!,
                                                headers: ["Authorization": appConfiguration.apiKey])
        let apiDataNetwork = NetworkService(config: config)
        return DataTransferService(networkService: apiDataNetwork)
    }()

    lazy var imageDataTransferService = {
        let config = APIDataNetworkConfigurable()
        let imagesDataNetwork = NetworkService(config: config)
        return DataTransferService(networkService: imagesDataNetwork)
    }()

    // MARK: - Cache
    let imageCache = ImageCache()

    // MARK: - DIContainers of scenes
    func makeCafeSceneDIContainer() -> CafeSceneDIContainer {
        let dependencies = CafeSceneDIContainer.Dependencies(dataTransferService: apiDataTransferService,
                                                             imageDataTransferService: imageDataTransferService,
                                                             imageCache: imageCache)
        return CafeSceneDIContainer(dependencies: dependencies)
    }

}

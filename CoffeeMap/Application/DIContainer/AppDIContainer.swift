//
//  AppDIContainer.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/4.
//

import Foundation

final class AppDIContainer {

    let appConfiguration = AppConfiguration()

    lazy var apiDataTransferService = {
        let config = APIDataNetworkConfigurable(baseURL: URL(string: self.appConfiguration.baseURL)!,
                                                headers: ["Authorization": self.appConfiguration.apiKey])
        let apiDataNetwork = NetworkService(config: config)
        return DataTransferService(networkService: apiDataNetwork)
    }
    
//    func make
}

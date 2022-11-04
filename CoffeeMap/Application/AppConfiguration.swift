//
//  AppConfiguration.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/4.
//

final class AppConfiguration {
    // Define environment
    enum Environment {
        case debug
        case release
    }

    let current: Environment
    private(set) var apiKey: String!
    
    init() {
        #if DEBUG
        current = .debug
        #elseif RELEASE
        current = .release
        #endif
        apiKey = getAPIKey()
    }
    
    private func getAPIKey() -> String {
        #if DEBUG
        return "" // set api key here
        #elseif RELEASE
        return ""
        #endif
    }

    private func getbaseURL() -> String {
        #if DEBUG
        return "https://api.foursquare.com"
        #elseif RELEASE
        return "https://api.foursquare.com"
        #endif
    }
}

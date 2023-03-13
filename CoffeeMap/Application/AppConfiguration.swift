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
    private(set) var baseURL: String!

    init() {
        #if DEBUG
        current = .debug
        #elseif RELEASE
        current = .release
        #endif
        apiKey = getAPIKey()
        baseURL = getBaseURL()
    }

    private func getAPIKey() -> String {
        #if DEBUG
        return ""
        #elseif RELEASE
        return ""
        #endif
    }

    private func getBaseURL() -> String {
        #if DEBUG
        return "https://api.foursquare.com"
        #elseif RELEASE
        return "https://api.foursquare.com"
        #endif
    }
}

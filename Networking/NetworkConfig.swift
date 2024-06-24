//
//  NetworkConfig.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

import Foundation

public protocol NetworkConfigurableType {
    // Why baseURL is an optional type? When we use path as the full path, we don't need to pass baseURL anymore
    var baseURL: URL? { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

public struct APIDataNetworkConfigurable: NetworkConfigurableType {
    public let baseURL: URL?
    public let headers: [String: String]
    public let queryParameters: [String: String]

    public init(baseURL: URL? = nil,
                headers: [String: String] = [:],
                queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}

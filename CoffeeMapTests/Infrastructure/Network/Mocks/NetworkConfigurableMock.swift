//
//  NetworkConfigurableMock.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/20.
//

import Foundation
@testable import Networking

struct NetworkConfigurableMock: NetworkConfigurableType {
    var baseURL: URL? = URL(string: "https://mock.testing.com")
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}

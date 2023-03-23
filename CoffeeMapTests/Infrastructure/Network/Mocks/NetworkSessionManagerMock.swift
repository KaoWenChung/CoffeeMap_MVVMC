//
//  NetworkSessionManagerMock.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/20.
//

import XCTest
@testable import CoffeeMap

struct NetworkSessionManagerMock: NetworkSessionManagerType {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    let expectation: XCTestExpectation?
    init(response: HTTPURLResponse?,
         data: Data?,
         error: Error?,
         expectation: XCTestExpectation?) {
        self.response = response
        self.data = data
        self.error = error
        self.expectation = expectation
    }
    func request(_ request: URLRequest) async throws -> DataResponse {
        expectation?.fulfill()
        guard let response, let data else {
            throw error ?? RequestError.noResponse
        }
        return (data, response)
    }
}

private enum RequestError: Error {
    case noResponse
}

//
//  SearchCafeUseCaseMock.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/15.
//

import XCTest
@testable import CoffeeMap

final class SearchCafeUseCaseMock: SearchCafeListUseCaseType {
    let response: [CafeTableViewCellModel]
    let error: Error?
    let expectation: XCTestExpectation?
    init(response: [CafeTableViewCellModel],
         error: Error?,
         expectation: XCTestExpectation?) {
        self.response = response
        self.error = error
        self.expectation = expectation
    }
    func execute(request: CafePlaceRequestDTO) async throws -> ([CafeTableViewCellModel], CancellableType) {
        expectation?.fulfill()
        if let error = error {
            throw error
        }
        return (response, CancellableMock())
    }
}

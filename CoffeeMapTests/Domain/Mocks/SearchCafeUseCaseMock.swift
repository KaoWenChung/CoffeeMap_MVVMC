//
//  SearchCafeUseCaseMock.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/15.
//

import XCTest
@testable import CoffeeMap

final class SearchCafeUseCaseMock: SearchCafeUseCaseType {
    let response: [CafeListTableViewCellModel]
    let error: Error?
    let expectation: XCTestExpectation
    init(response: [CafeListTableViewCellModel],
         error: Error?,
         expectation: XCTestExpectation) {
        self.response = response
        self.error = error
        self.expectation = expectation
    }
    func execute(request: CofeRequestDTO) async throws -> ([CafeListTableViewCellModel], CancellableType) {
        expectation.fulfill()
        if let error = error {
            throw error
        }
        return (response, CancellableMock())
    }
}

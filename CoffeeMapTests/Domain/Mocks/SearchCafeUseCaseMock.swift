//
//  SearchCafeUseCaseMock.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/15.
//

import XCTest
@testable import CoffeeMap

final class SearchCafeUseCaseMock: SearchCafeListUseCaseType {
    
    let cafeListModel: CafeListModel
    let error: Error?
    let expectation: XCTestExpectation?
    init(cafeListModel: CafeListModel,
         error: Error?,
         expectation: XCTestExpectation?) {
        self.cafeListModel = cafeListModel
        self.error = error
        self.expectation = expectation
    }
    func execute(request: CafePlaceRequestDTO) async throws -> CafeListModel {
        expectation?.fulfill()
        if let error = error {
            throw error
        }
        return cafeListModel
    }
}

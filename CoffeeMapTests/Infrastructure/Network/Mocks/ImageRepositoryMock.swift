//
//  CancellableMock.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/15.
//

@testable import CoffeeMap
import UIKit
import XCTest

final class ImageRepositoryMock: ImageRepositoryType {
    let response: UIImage?
    let error: Error?
    let expectation: XCTestExpectation?
    init(response: UIImage?,
         error: Error?,
         expectation: XCTestExpectation?) {
        self.response = response
        self.error = error
        self.expectation = expectation
    }
    func fetchImage(with imagePath: String) async throws -> UIImage? {
        expectation?.fulfill()
        guard let response else {
            throw error ?? ImageError.noResponse
        }
        return response
    }
}
private enum ImageError: Error {
    case noResponse
}

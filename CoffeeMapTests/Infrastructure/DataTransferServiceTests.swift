//
//  DataTransferServiceTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/22.
//

import XCTest
@testable import CoffeeMap

// MARK: - Mock Data
private struct MockResponseData: Decodable {
    let name: String
}

// MARK: - Tests
final class DataTransferServiceTests: XCTestCase {

    func testReceivedValidJSONResponse_decodeResponseToObject() {
        let expectation = expectation(description: "should decode response to object")
        let sut = makeSUT(mockData: #"{"name": "Mike"}"#)
        // when
        Task.init {
            do {
                let mockEndpoint = Endpoint<MockResponseData>(path: "https://mock.endpoint.com", method: .get)
                let value: MockResponseData = try await sut.request(with: mockEndpoint)
                XCTAssertEqual(value.name, "Mike")
                expectation.fulfill()
            } catch {
                XCTFail("Decoding mock object failure")
            }
        }
        // result
        wait(for: [expectation], timeout: 1)
    }

    func testReceivedInvalidResponse_decodeNoObjectThrowError() {
        let expectation = expectation(description: "Should throw error of network")
        let sut = makeSUT(mockData: #"{"gender": "man"}"#)
        // when
        Task.init {
            do {
                let mockEndpoint = Endpoint<MockResponseData>(path: "https://mock.endpoint.com", method: .get)
                let _: MockResponseData = try await sut.request(with: mockEndpoint)
                XCTFail("Should not successfully decode data")
            } catch {
                expectation.fulfill()
            }
        }
        // result
        wait(for: [expectation], timeout: 1)
    }
    // MARK: - Helper
    private func makeSUT(mockData: String) -> DataTransferServiceType {
        // given
        let mockConfig = NetworkConfigurableMock()
        let mockData = mockData.data(using: .utf8)
        let mockSessionManager = NetworkSessionManagerMock(response: HTTPURLResponse(), data: mockData!, error: nil, expectation: nil)
        let networkService = NetworkService(config: mockConfig, sessionManager: mockSessionManager)
        
        return DataTransferService(networkService: networkService)
    }
}

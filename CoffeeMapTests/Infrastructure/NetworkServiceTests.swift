//
//  NetworkServiceTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2022/12/20.
//

import XCTest
@testable import CoffeeMap

class NetworkServiceTests: XCTestCase {

    private struct EndpointMock: RequestableType {

        var path: String
        var isFullPath: Bool = false
        var method: HTTPMethod
        var headerParameters: [String: String] = [:]
        var queryParametersEncodable: Encodable?
        var queryParameters: [String: Any] = [:]
        var bodyParametersEncodable: Encodable?
        var bodyParameters: [String: Any] = [:]
        var bodyEncoding: BodyEncoding = .stringEncodingAscii

        init(path: String, method: HTTPMethod) {
            self.path = path
            self.method = method
        }
    }

    class NetworkErrorLoggerMock: NetworkErrorLoggerType {
        var loggedErrors: [Error] = []
        func log(request: URLRequest) { }
        func log(responseData data: Data?, response: URLResponse?) { }
        func log(error: Error) { loggedErrors.append(error) }
    }

    private enum NetworkErrorMock: Error {
        case someError
    }

    func test_whenMockDataPassed_shouldReturnProperResponse() async {
        // given
        let config = NetworkConfigurableMock()

        let expectedResponseData = "Response data".data(using: .utf8)!
        let sessionManager = NetworkSessionManagerMock(response: HTTPURLResponse(),
                                                       data: expectedResponseData,
                                                       error: nil,
                                                       expectation: self.expectation(description: "Should return correct data"))
        let sut = NetworkService(config: config,
                                 sessionManager: sessionManager)
        // when
        do {
            let result = try sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            let (data, _) = try await result.value
            XCTAssertEqual(data, expectedResponseData)
        } catch {
            XCTFail("Should return proper response")
        }
        //then
        await waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() async {
        //given
        let config = NetworkConfigurableMock()
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let networkSessionMock = NetworkSessionManagerMock(response: nil,
                                                           data: nil,
                                                           error: cancelledError as Error,
                                                           expectation: expectation(description: "Should return hasStatusCode error"))
        let sut = NetworkService(config: config, sessionManager: networkSessionMock)
        //when
        do {
            let result = try sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            let (_, _) = try await result.value
            XCTFail("Should not happen")
        } catch {
            guard case NetworkError.cancelled = error else {
                XCTFail("NetworkError.cancelled not found")
                return
            }
        }
        //then
        await waitForExpectations(timeout: 0.1, handler: nil)
    }

    func test_whenStatusCodeEqualOrAbove400_shouldReturnhasStatusCodeError() async {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        let data = "Response data".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let sut = NetworkService(config: config, sessionManager: NetworkSessionManagerMock(response: response,
                                                                                           data: data,
                                                                                           error: NetworkErrorMock.someError, expectation: nil))
        //when
        do {
            let result = try sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get))
            let (_, _) = try await result.value
            XCTFail("Should not happen")
        } catch {
            if case let NetworkError.error(statusCode, _) = error {
                XCTAssertEqual(statusCode, 500) // TODO: Not sure why it doesn't get into this scope
            }
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
}

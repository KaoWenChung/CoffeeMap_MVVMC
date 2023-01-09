//
//  NetworkService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

import Foundation

public protocol NetworkServiceType {
    @discardableResult
    func request(endpoint: RequestableType) throws -> URLTask
}

public protocol NetworkSessionManagerType {
    typealias DataResponse = (Data, URLResponse)
    func request(_ request: URLRequest) async throws -> DataResponse
}

public protocol NetworkErrorLoggerType {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

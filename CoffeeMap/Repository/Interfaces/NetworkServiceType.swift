//
//  NetworkService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

import Foundation

public protocol NetworkServiceType {

    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    func request(endpoint: RequestableType, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

public protocol NetworkCancellable {
    func cancel()
}

public protocol NetworkSessionManagerType {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

public protocol NetworkErrorLoggerType {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

//
//  DataTransferServiceType.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/3.
//

import Foundation

public protocol DataTransferServiceType {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    func request<T: Decodable, E: ResponseRequestableType>(with endpoint: E, completion: @escaping CompletionHandler<T>) async throws -> NetworkCancellable? where E.Response == T
    func request<E: ResponseRequestableType>(with endpoint: E, completion: @escaping CompletionHandler<Void>) async throws -> NetworkCancellable? where E.Response == Void
}

public protocol DataTransferErrorResolverType {
    func resolve(error: NetworkError) -> Error
}

public protocol ResponseDecoderType {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol DataTransferErrorLoggerType {
    func log(error: Error)
}

public protocol ResponseRequestableType: RequestableType {
    associatedtype Response
    var responseDecoder: ResponseDecoderType { get }
}

//  DataTransferService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/3.
//

import Foundation

public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

public final class DataTransferService {
    private let networkService: NetworkServiceType
    private let errorResolver: DataTransferErrorResolverType
    private let errorLogger: DataTransferErrorLoggerType
    public init(networkService: NetworkServiceType,
                errorResolver: DataTransferErrorResolverType = DataTransferErrorResolver(),
                errorLogger: DataTransferErrorLoggerType = DataTransferErrorLogger()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension DataTransferService: DataTransferServiceType {
    public func request<T: Decodable, E: ResponseRequestableType>(
        with endpoint: E
    ) async throws -> T where E.Response == T {
        do {
            let task = try networkService.request(endpoint: endpoint)
            let (data, _) = try await task.value
            let result: T = try decode(data: data, decoder: endpoint.responseDecoder)
            return result
        } catch let error as NetworkError {
            errorLogger.log(error: error)
            let error = self.resolve(networkError: error)
            throw error
        }
    }

    public func request<T: Decodable, E: ResponseRequestableType>(
        with endpoint: E
    ) async throws -> (T, URLResponse) where E.Response == T {
        do {
            let task = try networkService.request(endpoint: endpoint)
            let (data, response) = try await task.value
            let result: T = try decode(data: data, decoder: endpoint.responseDecoder)
            return (result, response)
        } catch let error as NetworkError {
            errorLogger.log(error: error)
            let error = self.resolve(networkError: error)
            throw error
        }
    }

    public func request<E>(
        with endpoint: E
    ) async throws where E: ResponseRequestableType, E.Response == Void {
        do {
            try networkService.request(endpoint: endpoint)
        } catch let error as NetworkError {
            self.errorLogger.log(error: error)
            let error = self.resolve(networkError: error)
            throw error
        }
    }

    // MARK: - Private
    private func decode<T: Decodable>(data: Data, decoder: ResponseDecoderType) throws -> T {
        do {
            let result: T = try decoder.decode(data)
            return result
        } catch {
            errorLogger.log(error: error)
            throw DataTransferError.parsing(error)
        }
    }

    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

// MARK: - Logger
public final class DataTransferErrorLogger: DataTransferErrorLoggerType {
    public init() {}
    public func log(error: Error) {
        printIfDebug("-----------------")
        printIfDebug(error.localizedDescription)
    }
}

// MARK: - Error Resolver
public final class DataTransferErrorResolver: DataTransferErrorResolverType {
    public init() {}
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - Response Decoders
public class JSONResponseDecoder: ResponseDecoderType {
    private let jsonDecoder = JSONDecoder()
    public init() {}
    public func decode<T>(_ data: Data) throws -> T where T: Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoderType {
    public init() {}
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    public func decode<T>(_ data: Data) throws -> T where T: Decodable {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default],
                                                debugDescription: "Expected data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}

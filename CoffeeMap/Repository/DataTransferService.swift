//
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
    public func request<T: Decodable, E: ResponseRequestableType>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where T : Decodable, T == E.Response, E : ResponseRequestableType {
        return networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async {
                    completion(result)
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func request<E>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E : ResponseRequestableType, E.Response == () {
        return networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    // MARK: - Private methods
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoderType) -> Result<T, DataTransferError> {
        do {
            guard let data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }

    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(error)
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
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoderType {
    public init() {}
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}

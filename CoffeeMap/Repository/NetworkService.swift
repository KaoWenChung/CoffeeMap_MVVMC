//
//  BaseRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case statusCode
    case invalidImage
    case invalidURL
    case cancelled
    case notConnected
    case other(Error)
}

extension URLSessionTask: NetworkCancellable {}

public struct NetworkService {
    private let config: NetworkConfigurableType
    private let sessionManager: NetworkSessionManagerType
    private let logger: NetworkErrorLoggerType
    init(config: NetworkConfigurableType,
         sessionManager: NetworkSessionManagerType = NetworkSessionManager(),
         logger: NetworkErrorLoggerType = NetworkErrorLogger()) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }

    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            print(request.url)
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
    
        logger.log(request: request)

        return sessionDataTask
    }

    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .other(error)
        }
    }
}

extension NetworkService: NetworkServiceType {
    public func request(endpoint: RequestableType, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.invalidURL))
            return nil
        }
    }
}

public class NetworkSessionManager: NetworkSessionManagerType {
    public init() {}
    public func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

public final class NetworkErrorLogger: NetworkErrorLoggerType {
    public func log(request: URLRequest) {
        print("-----------------")
        print("request: \(request.url?.description ?? "")")
        print("headers: \(request.allHTTPHeaderFields ?? [:])")
        print("method: \(request.httpMethod ?? "")")
        if let httpBody = request.httpBody {
            if let result = try? JSONSerialization.jsonObject(with: httpBody) as? [String: AnyObject] {
                printIfDebug("Body: \(result)")
            } else if let resultString = String(data: httpBody, encoding: .utf8) {
                printIfDebug("Body: \(resultString)")
            }
        }
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data) as? [String: AnyObject] {
            printIfDebug("responseData:\(dataDict)")
        }
    }
    
    public func log(error: Error) {
        printIfDebug(error.localizedDescription)
    }
    
}

func printIfDebug(_ content: String) {
    #if DEBUG
    print(content)
    #endif
}

// MARK: - Legacy code
protocol APIServiceType {
    func request<T: Decodable>(request: URLRequest) async throws -> T
}

struct URLSessionAPIService: APIServiceType {

    func request<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode
        }
        do {
            // Parse the data
            let deconder = JSONDecoder()
            let jsonData = try deconder.decode(T.self, from:  data)
            return jsonData
        } catch let error {
            throw error
        }
    }

}



//
//  Endpoint.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

public class Endpoint<R>: ResponseRequestableType {
    public typealias Response = R
    
    public let path: String
    public let isFullPath: Bool
    public let method: HTTPMethod
    public let headerParameters: [String: String]
    public let queryParametersEncodable: Encodable?
    public let queryParameters: [String: Any]
    public let bodyParametersEncodable: Encodable?
    public let bodyParameters: [String: Any]
    public let bodyEncoding: BodyEncoding
    public let responseDecoder: ResponseDecoderType
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod,
         headerParameters: [String : String] = [:],
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String : Any] = [:],
         bodyParametersEncodable: Encodable? = nil,
         bodyParameters: [String : Any] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: ResponseDecoderType = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
    }
}

public protocol RequestableType {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethod { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoding: BodyEncoding { get }
    
    func urlRequest(with networkConfig: NetworkConfigurableType) throws -> URLRequest
}

enum RequestGenerationError: Error {
    case components
}

extension ResponseRequestableType {
    func url(with networkConfig: NetworkConfigurableType) throws -> URL {
        let baseURL = getBaseURL(networkConfig.baseURL.absoluteString)
        let endpoint = isFullPath ? path : baseURL.appending(path)
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        let queryParameters = try queryParametersEncodable?.toDictionary() ?? queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        networkConfig.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    private func getBaseURL(_ absoluteString: String) -> String {
        return absoluteString.last != "/" ? absoluteString + "/" : absoluteString
    }
    public func urlRequest(with networkConfig: NetworkConfigurableType) throws -> URLRequest {
        let url = try self.url(with: networkConfig)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = networkConfig.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }

    private func encodeBody(bodyParameters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParameters)
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
}

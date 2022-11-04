//
//  CafePlacesRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

final class CafePlacesRepository2 {
    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

//extension CafePlacesRepository2: CafePlacesRepositoryType {
//    func getPlace(param: GetPlaceParamModel) async throws -> GetPlaceResponseModel {
//        
//    }
//}

final class CafePlacesRepository: CafePlacesRepositoryType {

    // TODO: ADD API KEY HERE
    private let apiKey: String = ""

    private var headers: [String: String] {
        return [
            "Authorization": apiKey
          ]
    }

    let apiService: APIServiceType

    init(apiService: APIServiceType = URLSessionAPIService()) {
        self.apiService = apiService
    }

    private enum PlacesURL {
        case getPlace
        // TODO: get photo
        case getPhoto
        func urlString() -> String {
            let domainPath: String = "https://api.foursquare.com/v3/places/"
            switch self {
            case .getPlace:
                return domainPath + "search"
            case .getPhoto:
                return domainPath
            }
        }
    }

    func addParam2URLComponent(param: GetPlaceParamModel, urlComponent: inout URLComponents) {
        let paramDictionary: [String: Any]? = param.dictionary
        if let _paramDictionary = paramDictionary {
            urlComponent.setQueryItemsBy(dictionary: _paramDictionary)
        }
    }

    func getPlace(param: GetPlaceParamModel) async throws -> GetPlaceResponseModel {
        let urlStr = PlacesURL.getPlace.urlString()
        guard var urlComponent = URLComponents(string: urlStr) else {
            throw NetworkError.invalidURL
        }
        addParam2URLComponent(param: param, urlComponent: &urlComponent)
        guard let _url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        return try await get(url: _url)
    }

    // TODO: Replace to another component
    func get<T: Decodable>(url: URL) async throws -> T {
        let urlRequest = NSMutableURLRequest(url: url,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers

        return try await apiService.request(request: urlRequest as URLRequest)
    }

}

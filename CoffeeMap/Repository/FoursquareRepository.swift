//
//  FoursquareRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

protocol FoursquareRepositoryDelegate {

    func getPlace(param: GetPlaceParamModel, completion: ((Result<GetPlaceResponseModel>) -> Void)?)

}

final class FoursquareRepository: FoursquareRepositoryDelegate {

    // TODO: ADD API KEY HERE
    private let apiKey: String = ""

    private var headers: [String: String] {
        return [
            "Accept": "application/json",
            "Authorization": apiKey
          ]
    }

    let apiService: APIService

    init(apiService: APIService = URLSessionAPIService()) {
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

    func getPlace(param: GetPlaceParamModel, completion: ((Result<GetPlaceResponseModel>) -> Void)?) {
        let urlStr = PlacesURL.getPlace.urlString()
        guard var urlComponent = URLComponents(string: urlStr) else { return }
        addParam2URLComponent(param: param, urlComponent: &urlComponent)
        guard let _url = urlComponent.url else { return }
        get(url: _url, completion: completion)
    }

    func get<T: Decodable>(url: URL, completion: ((Result<T>) -> Void)?) {
        let urlRequest = NSMutableURLRequest(url: url,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers

        apiService.request(request: urlRequest as URLRequest, completion: completion)
    }

}

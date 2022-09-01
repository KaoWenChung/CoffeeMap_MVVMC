//
//  FoursquareRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

protocol FoursquareRepositoryDelegate {
    func getPlace(param: GetPlaceParamModel, completion: @escaping ((Result<GetPlaceResponseModel>) -> Void))
}

class FoursquareRepository: BaseRepository, FoursquareRepositoryDelegate {

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

    func getPlace(param: GetPlaceParamModel, completion: @escaping ((Result<GetPlaceResponseModel>) -> Void)) {
        let urlStr = PlacesURL.getPlace.urlString()
        guard var urlComponent = URLComponents(string: urlStr) else { return }
        let test: [String: Any]? = param.dictionary
        if let test = test {
            urlComponent.addParameters(test)
        }
        guard let _url = urlComponent.url else { return }
        get(url: _url, completion: completion)
    }

}

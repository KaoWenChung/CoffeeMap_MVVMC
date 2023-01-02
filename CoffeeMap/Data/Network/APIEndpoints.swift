//
//  APIEndpoints.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/7.
//

import Foundation

struct APIEndpoints {
    static func getCafePlaces(with request: CafePlaceRequestDTO) -> Endpoint<CafePlaceResponseDTO> {
        return Endpoint(path: "v3/places/search",
                        method: .get,
                        queryParametersEncodable: request)
    }

    static func getCafePhotos(with request: CafePhotosRequestDTO) -> Endpoint<[CafePhotosResponseDTO]> {
        return Endpoint(path: "v3/places/\(request.fsqId)/photos",
                        method: .get)
    }

    static func getImage(path: String) -> Endpoint<Data> {
        return Endpoint(path: path,
                        isFullPath: true,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}

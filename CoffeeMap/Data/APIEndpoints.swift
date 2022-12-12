//
//  APIEndpoints.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/7.
//

//import Foundation

struct APIEndpoints {
    static func getCofaPlaces(with request: CofeRequestDTO) -> Endpoint<GetPlaceResponseDTO> {
        return Endpoint(path: "v3/places/search",
                        method: .get,
                        queryParametersEncodable: request)
    }
}

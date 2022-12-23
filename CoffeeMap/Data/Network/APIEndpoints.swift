//
//  APIEndpoints.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/7.
//

//import Foundation

struct APIEndpoints {
    static func getCafePlaces(with request: CafePlaceRequestDTO) -> Endpoint<CafePlaceResponseDTO> {
        return Endpoint(path: "v3/places/search",
                        method: .get,
                        queryParametersEncodable: request)
    }
    static func getCafeDetail(with request: CafeDetailRequestDTO) -> Endpoint<CafeDetailResponseDTO> {
        return Endpoint(path: "v3/places",
                        method: .get,
                        queryParametersEncodable: request)
    }
}

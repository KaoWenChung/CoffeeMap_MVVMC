//
//  CafePlaceResponseDTO+Stub.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/3/13.
//

@testable import CoffeeMap

extension CafePlaceResponseDTO {
    static func stub(results: [GetPlaceResultDTO] = []) -> Self {
        CafePlaceResponseDTO(results: results)
    }
}

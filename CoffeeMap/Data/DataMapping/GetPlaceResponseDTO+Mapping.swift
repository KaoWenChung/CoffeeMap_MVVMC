//
//  GetPlaceResponseDTO+Mapping.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//
// TODO: 
extension GetPlaceResponseDTO {
    func toDomain() -> GetPlaceResponseModel {
        return .init(context: nil, results: nil)
    }
}

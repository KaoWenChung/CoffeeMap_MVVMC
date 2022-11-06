//
//  CafePlacesRepositoryType.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

protocol CafePlacesRepository2Type {

    func getPlace(param: GetPlaceParamModel) async throws -> CancellableType?

}

protocol CafePlacesRepositoryType {

    func getPlace(param: GetPlaceParamModel) async throws -> GetPlaceResponseModel

}

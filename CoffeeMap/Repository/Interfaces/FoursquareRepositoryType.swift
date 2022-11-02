//
//  FoursquareRepositoryType.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

protocol FoursquareRepositoryType {

    func getPlace(param: GetPlaceParamModel) async throws -> GetPlaceResponseModel

}

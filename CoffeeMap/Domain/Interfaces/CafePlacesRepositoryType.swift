//
//  CafePlacesRepositoryType.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

protocol CafePlacesRepositoryType {

    func getPlace(request: CofeRequestDTO) async throws -> ([CafeListTableViewCellModel], CancellableType)

}

//
//  SearchCafePlacesUseCase.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/7.
//

import Foundation

protocol SearchCafeUseCaseType {
    func execute(request: CofeRequestDTO) async throws -> ([CafeListTableViewCellModel], CancellableType)
}

final class SearchCafeUseCase: SearchCafeUseCaseType {
    
    private let cafeRepository: CafePlacesRepositoryType
    
    init(cafeRepository: CafePlacesRepositoryType) {
        self.cafeRepository = cafeRepository
    }
    
    func execute(request: CofeRequestDTO) async throws -> ([CafeListTableViewCellModel], CancellableType) {
        return try await cafeRepository.getPlace(request: request)
    }
    
    
}

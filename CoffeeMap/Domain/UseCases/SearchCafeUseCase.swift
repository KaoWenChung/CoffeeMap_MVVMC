//
//  SearchCafePlacesUseCase.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/7.
//

import Foundation

protocol SearchCafeUseCaseType {
    func execute(request: CofeRequestDTO, completion: @escaping (Result<[CafeListTableViewCellModel], Error>) -> Void) async throws -> CancellableType?
}

final class SearchCafeUseCase: SearchCafeUseCaseType {
    
    private let cafeRepository: CafePlacesRepository2Type
    
    init(cafeRepository: CafePlacesRepository2Type) {
        self.cafeRepository = cafeRepository
    }
    
    func execute(request: CofeRequestDTO, completion: @escaping (Result<[CafeListTableViewCellModel], Error>) -> Void) async throws -> CancellableType? {
        return try await cafeRepository.getPlace(param: request, completion: completion)
    }
    
    
}

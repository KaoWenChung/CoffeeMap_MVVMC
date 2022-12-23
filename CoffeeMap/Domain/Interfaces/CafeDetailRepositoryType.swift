//
//  CafeDetailRepositoryType.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/23.
//

protocol CafeDetailRepositoryType {
    func getPlaceDetail(request: CafeDetailRequestDTO) async throws -> (CafeDetailResponseDTO, CancellableType)
}

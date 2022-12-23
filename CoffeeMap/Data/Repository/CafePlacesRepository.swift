//
//  CafePlacesRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

struct CafePlacesRepository {
    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension CafePlacesRepository: CafePlacesRepositoryType {
    func getPlace(request: CafePlaceRequestDTO) async throws -> ([CafeListTableViewCellModel], CancellableType) {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getCafePlaces(with: request)
        let (data, taskCancellable) = try await dataTransferService.request(with: endpoint)
        task.networkTask = taskCancellable
        return (data.toDomain(), task)
    }
}

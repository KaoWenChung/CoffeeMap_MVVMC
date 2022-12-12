//
//  CafePlacesRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

final class CafePlacesRepository {
    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension CafePlacesRepository: CafePlacesRepositoryType {
    func getPlace(request: CofeRequestDTO) async throws -> ([CafeListTableViewCellModel], CancellableType) {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getCofaPlaces(with: request)
        let (data, taskCancellable) = try await dataTransferService.request(with: endpoint)
        task.networkTask = taskCancellable
        return (data.toDomain(), task)
    }
}

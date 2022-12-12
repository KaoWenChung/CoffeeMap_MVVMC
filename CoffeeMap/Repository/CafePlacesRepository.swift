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

extension CafePlacesRepository: CafePlacesRepository2Type {
    func getPlace(param: CofeRequestDTO, completion: @escaping (Result<[CafeListTableViewCellModel], Error>) -> Void) async throws -> CancellableType? {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getCofaPlaces(with: param)
        task.networkTask = try await self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                print(responseDTO)
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}

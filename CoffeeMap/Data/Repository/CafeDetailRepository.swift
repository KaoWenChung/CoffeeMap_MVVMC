//
//  CafeDetailRepository.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/23.
//

struct CafeDetailRepository {
    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension CafeDetailRepository: CafeDetailRepositoryType {
    func getPlaceDetail(request: CafeDetailRequestDTO) async throws -> (CafeDetailResponseDTO, CancellableType) {
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getCafeDetail(with: request)
        let (data, taskCancellable) = try await dataTransferService.request(with: endpoint)
        task.networkTask = taskCancellable
        return (data, task)
    }
}

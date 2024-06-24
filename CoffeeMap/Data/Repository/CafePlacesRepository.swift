//
//  CafePlacesRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation
import Networking

struct CafePlacesRepository {
    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension CafePlacesRepository: CafePlacesRepositoryType {
    private enum Content {
        static let link = "Link"
        static let lowerRange = "cursor="
        static let upperRange = ">"
    }

    func getPlace(request: CafePlaceRequestDTO) async throws -> CafePlaceResponse {
        let endpoint = APIEndpoints.getCafePlaces(with: request)
        let (data, response) = try await dataTransferService.request(with: endpoint)
        let cursor = getNextPageFromHeaders(response: response as? HTTPURLResponse)
        return CafePlaceResponse(cursor: cursor, response: data)
    }

    func getPhotos(request: CafePhotosRequestDTO) async throws -> [CafePhotoModel] {
        let endpoint = APIEndpoints.getCafePhotos(with: request)
        let data: [CafePhotosResponseDTO] = try await dataTransferService.request(with: endpoint)
        return data.toDomain()
    }

    // MARK: - Pagination
    private func getNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
        if let linkHeader = response?.allHeaderFields[Content.link] as? String {
            if let leftRange = linkHeader.range(of: Content.lowerRange),
                let rightRange = linkHeader.range(of: Content.upperRange) {
                var substring = linkHeader[leftRange.upperBound..<rightRange.lowerBound]
                if let index = substring.firstIndex(of: "&") {
                    substring.removeSubrange(index...)
                }
                return String(substring)
            }
        }
        return nil
    }
}

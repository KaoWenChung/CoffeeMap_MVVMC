//
//  CafePhotosResponseDTO+Mapping.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/2.
//

struct CafePhotosResponseDTO: Codable {
    let classifications: [String]?
    let createdAt: String?
    let height: Int?
    let id: String?
    let prefix: String?
    let suffix: String?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case classifications
        case createdAt = "created_at"
        case height
        case id
        case prefix
        case suffix
        case width
    }
}

extension CafePhotosResponseDTO {
    func toDomain() -> CafePhotoModel {
        CafePhotoModel(self)
    }
}

extension Array where Element == CafePhotosResponseDTO {
    func toDomain() -> [CafePhotoModel] {
        map { $0.toDomain() }
    }
}

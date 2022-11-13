//
//  GetPlaceResponseDTO+Mapping.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

extension GetPlaceResponseDTO {
    func toDomain() -> [CafeListTableViewCellModel] {
        var result: [CafeListTableViewCellModel] = []
        if let results {
            for item in results {
                result.append(CafeListTableViewCellModel(item))
            }
        }
        return result
    }
}

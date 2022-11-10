//
//  GetPlaceResponseDTO+Mapping.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

extension GetPlaceResponseDTO {
    func toDomain() -> [PlaceSearchTableViewCellRowModel] {
        var result: [PlaceSearchTableViewCellRowModel] = []
        if let results {
            for item in results {
                result.append(PlaceSearchTableViewCellRowModel(item))
            }
        }
        return result
    }
}

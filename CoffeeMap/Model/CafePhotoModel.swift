//
//  CafePhotoModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/2.
//

struct CafePhotoModel {
    let height: Int?
    let prefix: String?
    let suffix: String?
    let width: Int?
    init(_ data: CafePhotosResponseDTO) {
        height = data.height
        prefix = data.prefix
        suffix = data.suffix
        width = data.width
    }
}

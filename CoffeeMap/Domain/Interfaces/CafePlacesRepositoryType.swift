//
//  CafePlacesRepositoryType.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/2.
//

protocol CafePlacesRepositoryType {

    func getPlace(request: CafePlaceRequestDTO) async throws -> (CafePlaceResponseDTO, CancellableType)
    func getPhotos(request: CafePhotosRequestDTO) async throws -> [CafePhotoModel]

}

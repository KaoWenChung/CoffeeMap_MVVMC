//
//  SearchCafePlacesUseCase.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/7.
//

import Foundation

protocol SearchCafeListUseCaseType {
    func execute(request: CafePlaceRequestDTO) async throws -> ([CafeTableViewCellModel], CancellableType)
}

final class SearchCafeListUseCase: SearchCafeListUseCaseType {
    
    private let cafeRepository: CafePlacesRepositoryType
    
    init(cafeRepository: CafePlacesRepositoryType) {
        self.cafeRepository = cafeRepository
    }
    // It's going to fetch the cafe list to get their fsqID and then use them to fetch cafe photos of every each cafe entity 
    func execute(request: CafePlaceRequestDTO) async throws -> ([CafeTableViewCellModel], CancellableType) {
        let (cafeList, task) = try await cafeRepository.getPlace(request: request)
        var cafeCellModels: [CafeTableViewCellModel] = []
        if let results = cafeList.results {
            for result in results {
                if let id = result.fsqId {
                    let cafePhotoModel = try await cafeRepository.getPhotos(request: CafePhotosRequestDTO(fsqId: id))
                    cafeCellModels.append(CafeTableViewCellModel(result, photoModel: cafePhotoModel))
                }
                
            }
        }
        return (cafeCellModels, task)
    }
}

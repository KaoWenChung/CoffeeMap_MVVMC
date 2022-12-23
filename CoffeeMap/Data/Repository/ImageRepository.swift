//
//  ImageRepository.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/23.
//

import UIKit

protocol ImageRepositoryType {
    func fetchImage(with imagePath: String) async throws -> (UIImage?, CancellableType?)
}

struct ImageRepository {
    private let dataTransferService: DataTransferServiceType
    private let imageCache: ImageCacheType

    init(dataTransferService: DataTransferServiceType,
         imageCache: ImageCacheType) {
        self.dataTransferService = dataTransferService
        self.imageCache = imageCache
    }
}

extension ImageRepository: ImageRepositoryType {
    func fetchImage(with imagePath: String) async throws -> (UIImage?, CancellableType?) {
        let endpoint = APIEndpoints.getImage(path: imagePath)
        if let image = imageCache[imagePath] {
            return (image, nil)
        }
        let task = RepositoryTask()
        let (data, taskCancellable) = try await dataTransferService.request(with: endpoint)
        task.networkTask = taskCancellable
        let imageResult = UIImage(data:data)
        self.imageCache.insertImage(imageResult, for: imagePath)
        return (imageResult, task)
    }
}

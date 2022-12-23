//
//  ImageCache.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/23.
//

import UIKit

// Declares in-memory image cache
protocol ImageCacheType {
    // Returns the image associated with a given url
    func image(for url: String) -> UIImage?
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: String)
    // Removes the image of the specified url in the cache
    func removeImage(for url: String)
    // Accesses the value associated with the given key for reading and writing
    subscript(_ url: String) -> UIImage? { get set }
}

final class ImageCache {
    private lazy var imageCache: NSCache<AnyObject, UIImage> = {
            let cache = NSCache<AnyObject, UIImage>()
            cache.totalCostLimit = config.memoryLimit
            return cache
        }()
    
    private let config: Config

        struct Config {
            let memoryLimit: Int
            static let defaultConfig = Config(memoryLimit: 1024 * 1024 * 1) // 1 MB
        }

        init(config: Config = Config.defaultConfig) {
            self.config = config
        }
}

extension ImageCache: ImageCacheType {
    func image(for url: String) -> UIImage? {
        // search for image data
        if let image = imageCache.object(forKey: url as AnyObject) {
            return image
        }
        return nil
    }
    func insertImage(_ image: UIImage?, for url: String) {
        guard let image = image else {
            return removeImage(for: url)
        }
        let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imgData.count
        imageCache.setObject(image, forKey: url as AnyObject, cost: imageSize)
    }
    func removeImage(for url: String) {
        imageCache.removeObject(forKey: url as AnyObject)
    }
    subscript(_ key: String) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}


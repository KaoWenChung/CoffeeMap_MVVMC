//
//  UIImageView.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/23.
//

import UIKit

extension UIImageView {
    /// Download image by URL
    func downloaded(imageLoader: ImageRepositoryType,
                    from url: String?,
                    placeholderImage: String = ImageContents.noImage,
                    contentMode mode: ContentMode = .scaleAspectFit) async {
        contentMode = mode
        image = UIImage(named: placeholderImage)
        guard let url, !url.isEmpty else { return }
        if let image = try? await imageLoader.fetchImage(with: url) {
            self.image = image
        }
    }
}

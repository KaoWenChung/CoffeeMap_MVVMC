//
//  ImageRotatorCollectionViewCell.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

class ImageRotatorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var timeLabel: UILabel!
    private var imageLoadTask: CancellableType?
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        timeLabel.text = nil
        imageView.image = nil
    }

    func setupView(time: String, imageURL: String, imageRepository: ImageRepositoryType) {
        timeLabel.text = time
        let task = Task {
            await imageView.downloaded(imageLoader: imageRepository, from: imageURL)
        }
        imageLoadTask = task
        Task.init {
            await task.value
        }
    }
}

//
//  ImageRotatorCollectionViewCell.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

final class ImageRotatorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var timeLabel: UILabel!
    private var imageLoadTask: CancellableType?
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        timeLabel.text = nil
        imageView.image = nil
    }

    func setupView(model: ImageRotatorCollectionCellViewModel, imageRepository: ImageRepositoryType) {
        timeLabel.text = model.date
        let task = Task {
            await imageView.downloaded(imageLoader: imageRepository, from: model.imageURL)
        }
        imageLoadTask = task
        Task.init {
            await task.value
        }
    }
}

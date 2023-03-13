//
//  CafeListTableViewCell.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

final class CafeTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    private var imageLoadTask: CancellableType?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        nameLabel.text = nil
        addressLabel.text = nil
        distanceLabel.text = nil
        iconImageView.image = nil
    }

    func setupView(_ rowModel: CafeTableViewCellModel, imageRepository: ImageRepositoryType) {
        nameLabel.text = rowModel.name
        addressLabel.text = rowModel.address
        distanceLabel.text = rowModel.distance
        let task = Task {
            await iconImageView.downloaded(imageLoader: imageRepository, from: rowModel.iconURL)
        }
        imageLoadTask = task
    }
}

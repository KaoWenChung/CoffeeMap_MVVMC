//
//  ImageViewerCollectionViewCell.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/17.
//

import UIKit

protocol ImageViewerCollectionViewCellDelegate: AnyObject {
    func imageViewerCollectionViewCell(contentOffset offset: CGFloat)
}

final class ImageViewerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak private var scrollView: UIScrollView!

    weak var delegate: ImageViewerCollectionViewCellDelegate?

    private var imageLoadTask: CancellableType?

    func setImage(_ model: ImageViewerCollectionCellViewModel, imageRepository: ImageRepositoryType) {
        scrollView.delegate = self
        scrollView.zoomScale = 1
        // Update image
        let task = Task {
            await imageView.downloaded(imageLoader: imageRepository, from: model.imageURL)
        }
        imageLoadTask = task
        Task.init {
            await task.value
        }
    }
    func zoomOut() {
        scrollView.zoomScale = 1
    }
}

extension ImageViewerCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioWidth = imageView.frame.width / image.size.width
                let ratioHeight = imageView.frame.height / image.size.height
                let ratio = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditionTop = newHeight * scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.zoomScale == 1 else { return }
        delegate?.imageViewerCollectionViewCell(contentOffset: scrollView.contentOffset.y)
    }
}

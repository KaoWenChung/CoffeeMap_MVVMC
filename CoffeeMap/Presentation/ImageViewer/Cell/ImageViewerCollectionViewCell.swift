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
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var scrollView: UIScrollView!

    weak var delegate: ImageViewerCollectionViewCellDelegate?

    private var imageLoadTask: CancellableType?

    override func prepareForReuse() {
        imageLoadTask?.cancel()
    }

    func setupView(_ model: ImageViewerCollectionCellViewModel, imageRepository: ImageRepositoryType) {
        scrollView.delegate = self
        scrollView.zoomScale = 1
        // Update image
        let task = Task {
            await imageView.downloaded(imageLoader: imageRepository, from: model.imageURL)
        }
        imageLoadTask = task
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
                let imageViewWidth = imageView.frame.width
                let scrollViewWidth = scrollView.frame.width
                let contentSizeWidth = scrollView.contentSize.width
                let newWidthCondition = conditionLeft ? newWidth - imageViewWidth : scrollViewWidth - contentSizeWidth
                let left = 0.5 * newWidthCondition
                let conditionTop = newHeight * scrollView.zoomScale > imageView.frame.height

                let imageHeight = imageView.frame.height
                let scrollViewHeight = scrollView.frame.height
                let contentSizeHeight = scrollView.contentSize.height
                let newHeightCondition = conditionTop ? newHeight - imageHeight : (scrollViewHeight - contentSizeHeight)
                let top = 0.5 * newHeightCondition
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

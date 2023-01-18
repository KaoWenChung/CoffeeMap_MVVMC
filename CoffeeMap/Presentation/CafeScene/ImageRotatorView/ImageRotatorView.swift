//
//  ImageRotatorView.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

final class ImageRotatorView: BaseXibView {
    @IBOutlet weak private(set) var imageCollectionView: UICollectionView!
    @IBOutlet weak private(set) var countLabel: UILabel!

    private var imageRepository: ImageRepositoryType?
    private var collectionViewAdapter: CollectionViewAdapter?
    private var viewModel: ImageRotatorViewModel?

    init() {
        super.init(frame: .zero)
        initView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    private func initView() {
        collectionViewAdapter = .init(imageCollectionView)
        collectionViewAdapter?.register(ImageRotatorCollectionViewCell.self)
        collectionViewAdapter?.delegate = self
        collectionViewAdapter?.didScrollDelegate = self
    }
    func setup(_ data: [ImageRotatorCollectionCellViewModel], imageRepository: ImageRepositoryType) {
        viewModel = ImageRotatorViewModel(imageCells: data)
        collectionViewAdapter?.updateData(data)
        self.imageRepository = imageRepository
        countLabel.text = "1/\(data.count)"
    }
}


extension ImageRotatorView: TableCollectionViewAdapterDelegate {
    func configure(model: AdapterItemModel, view: UIView, indexPath: IndexPath) {
        switch (model, view) {
        case (let model as ImageRotatorCollectionCellViewModel, let view as ImageRotatorCollectionViewCell):
            guard let imageRepository else { return }
            view.setupView(model: model, imageRepository: imageRepository)
        default:
            break
        }
    }
    
    func select(model: AdapterItemModel) {
//        let viewModel = ImageViewerViewModel(imageUrlList: viewModel., page: <#T##Int#>, pastImageRect: <#T##CGRect?#>)
//        let imageViewer: ImageViewerViewController.ini
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        let width = frame.width
        let height = frame.height
        return CGSize(width: width, height: height)
    }
}

extension ImageRotatorView: CollectionViewDidScrollDelegate {
    // Show index of images
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetPage = Int(scrollView.contentOffset.x / frame.width)
        countLabel.text = "\(offsetPage + 1)/\(viewModel?.imageCells.count ?? 0)"
    }
}

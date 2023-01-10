//
//  ImageRotatorView.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

final class ImageRotatorView: BaseXibView {
    @IBOutlet weak private var imageCollectionView: UICollectionView!
    @IBOutlet weak private var countLabel: UILabel!

    private var imageRepository: ImageRepositoryType?
    private var collectionViewAdapter: CollectionViewAdapter?

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
    }
    func setup(_ data: [ImageRotatorCollectionCellViewModel], imageRepository: ImageRepositoryType) {
        collectionViewAdapter?.updateData(data)
        self.imageRepository = imageRepository
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
        
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

struct ImageRotatorCollectionCellViewModel: AdapterItemModel {
    enum Content {
        static let imageSize: String = "64"
    }
    var type: UIView.Type { return ImageRotatorCollectionViewCell.self }
    let imageURL: String
    let date: String?
    init(_ photoModel: CafePhotoModel) {
        if let prefix = photoModel.prefix,
           let suffix = photoModel.suffix {
            imageURL = prefix + Content.imageSize + suffix
        } else {
            imageURL = ""
        }
        self.date = photoModel.createdAt
    }
}

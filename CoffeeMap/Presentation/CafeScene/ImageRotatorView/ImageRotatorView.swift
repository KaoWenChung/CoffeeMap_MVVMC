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
        let width = frame.width
        let height = frame.height
        return CGSize(width: width, height: height)
    }
}

struct ImageRotatorCollectionCellViewModel: AdapterItemModel {
    var type: UIView.Type { return ImageRotatorCollectionViewCell.self }
    let prefix: String?
    let suffix: String?
    let date: String?
    init(_ photoModel: CafePhotoModel) {
        prefix = photoModel.prefix
        suffix = photoModel.suffix
        self.date = photoModel.createdAt
    }
}

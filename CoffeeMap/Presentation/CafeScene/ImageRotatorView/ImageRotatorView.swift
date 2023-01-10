//
//  ImageRotatorView.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

final class ImageRotatorView: UIView {
    @IBOutlet weak private var imageCollectionView: UICollectionView!
    @IBOutlet weak private var countLabel: UILabel!
    private var collectionViewAdapter: CollectionViewAdapter?
    init() {
        super.init(frame: .zero)
        collectionViewAdapter = .init(imageCollectionView)
        collectionViewAdapter?.register(ImageRotatorCollectionViewCell.self)
        collectionViewAdapter?.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageRotatorView: TableCollectionViewAdapterDelegate {
    func configure(model: AdapterItemModel, view: UIView, indexPath: IndexPath) {
        
    }
    
    func select(model: AdapterItemModel) {
        
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

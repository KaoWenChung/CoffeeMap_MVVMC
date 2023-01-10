//
//  ImageRotatorView.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

final class ImageRotatorView: UIView {
    @IBOutlet weak private var imageCollectionView: UICollectionView!
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

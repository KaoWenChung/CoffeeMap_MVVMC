//
//  ImageRotatorViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/13.
//

final class ImageRotatorViewModel {
    let imageCells: [ImageRotatorCollectionCellViewModel]
    var page: Int = 1
    init(imageCells: [ImageRotatorCollectionCellViewModel]) {
        self.imageCells = imageCells
    }
}

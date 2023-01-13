//
//  ImageRotatorViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/13.
//

struct ImageRotatorViewModel {
    let imageCells: [ImageRotatorCollectionCellViewModel]
    init(imageCells: [ImageRotatorCollectionCellViewModel]) {
        self.imageCells = imageCells
    }
}

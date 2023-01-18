//
//  ImageViwerViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/17.
//

import CoreFoundation

protocol ImageViwerViewModelType {
    var imageUrlList: [String] { get }
    var pastImageRect: CGRect? { get }
    var isShowButtons: Bool { get }
    var page: Int { get }
    var isDismiss: Bool { get }
    func toggleShowButtons()
    func setPage(_ page: Int)
    func toggleDismiss()
}

final class ImageViewerViewModel: ImageViwerViewModelType {
    private(set) var isShowButtons: Bool = true
    private(set) var page: Int = 0
    private(set) var isDismiss: Bool = false
    let pastImageRect: CGRect?
    let imageUrlList: [String]

    init(imageUrlList: [String],
         page: Int,
         pastImageRect: CGRect?) {
        self.imageUrlList = imageUrlList
        self.page = page
        self.pastImageRect = pastImageRect
    }

    init(imageRotatorCells: [ImageRotatorCollectionCellViewModel],
         page: Int,
         pastImageRect: CGRect?) {
        self.imageUrlList = imageRotatorCells.map { $0.getOriginalImage() }
        self.page = page
        self.pastImageRect = pastImageRect
    }

    func toggleShowButtons() {
        isShowButtons.toggle()
    }
    
    func setPage(_ page: Int) {
        self.page = page
    }
    
    func toggleDismiss() {
        isDismiss.toggle()
    }
}

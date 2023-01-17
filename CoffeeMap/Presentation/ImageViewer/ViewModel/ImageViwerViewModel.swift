//
//  ImageViwerViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/17.
//

import CoreFoundation

protocol LTImageViwerViewModelType {
    
}

final class LTImageViwerViewModel: LTImageViwerViewModelType {
    let imageUrlList: [String]
    var isShowButtons: Bool = true
    var page: Int = 0
    var isDismiss: Bool = false
    let pastImageRect: CGRect?
    init(imageUrlList: [String], isShowButtons: Bool, page: Int, isDismiss: Bool, pastImageRect: CGRect?) {
        self.imageUrlList = imageUrlList
        self.isShowButtons = isShowButtons
        self.page = page
        self.isDismiss = isDismiss
        self.pastImageRect = pastImageRect
    }
}

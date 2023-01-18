//
//  ImageRotatorCollectionCellViewModelTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/1/18.
//

import XCTest
@testable import CoffeeMap

final class ImageRotatorCollectionCellViewModelTests: XCTestCase {
    func testInitViewModel_initByCafePhotoModel() {
        //given
        let mockResponse = makeResponse(height: 1080, prefix: "https://mock.com/img/", suffix: "/mockimage.jpg", width: 1920, createdAt: "2011-11-08T18:41:47.000Z")
        let cafePhotoModel = CafePhotoModel(mockResponse)
        let sut = ImageRotatorCollectionCellViewModel(cafePhotoModel)
        //then
        XCTAssertEqual(sut.date, "2011-11-08")
        XCTAssertEqual(sut.height, 1080)
        XCTAssertEqual(sut.width, 1920)
        XCTAssertEqual(sut.prefix, "https://mock.com/img/")
        XCTAssertEqual(sut.suffix, "/mockimage.jpg")
    }

    func testGetOriginalImage_hasData_getResult() {
        //given
        let mockResponse = makeResponse(height: 1080, prefix: "https://mock.com/img/", suffix: "/mockimage.jpg", width: 1920, createdAt: "2011-11-08T18:41:47.000Z")
        let cafePhotoModel = CafePhotoModel(mockResponse)
        let sut = ImageRotatorCollectionCellViewModel(cafePhotoModel)
        //when
        let originalImageURL = sut.getOriginalImage()
        //then
        XCTAssertEqual(originalImageURL, "https://mock.com/img/1920x1080/mockimage.jpg")
    }

    func testGetOriginalImage_hasIncorrectData_getEmptyResult() {
        //given
        let mockResponse = makeResponse(height: nil, prefix: "https://mock.com/img/", suffix: nil, width: 1920, createdAt: "2011-11-08T18:41:47.000Z")
        let cafePhotoModel = CafePhotoModel(mockResponse)
        let sut = ImageRotatorCollectionCellViewModel(cafePhotoModel)
        //when
        let originalImageURL = sut.getOriginalImage()
        //then
        XCTAssertEqual(originalImageURL, "")
    }

    // MARK: - Helper
    private func makeResponse(height: Int?,
                              prefix: String?,
                              suffix: String?,
                              width: Int?,
                              createdAt: String? = nil) -> CafePhotosResponseDTO {
        CafePhotosResponseDTO(classifications: nil,
                              createdAt: createdAt,
                              height: height,
                              id: nil,
                              prefix: prefix,
                              suffix: suffix,
                              width: width)
    }
}

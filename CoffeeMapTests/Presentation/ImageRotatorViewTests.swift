//
//  ImageRotatorViewTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/1/13.
//

import XCTest
import CoreLocation
@testable import CoffeeMap

final class ImageRotatorViewTests: XCTestCase {
    func testSetupView() throws {
        let getImageDataModel: [CafePhotosResponseDTO] = [
            CafePhotosResponseDTO.stub(),
            CafePhotosResponseDTO.stub()
        ]
        let cafePhotoModels = getImageDataModel.toDomain()
        let imageCellModels = cafePhotoModels.toImageRotatorColls()
        let sut = ImageRotatorView()
        sut.setup(imageCellModels, imageRepository: ImageRepositoryMock(response: nil, error: nil, expectation: nil))
        XCTAssertEqual(sut.countLabel.text, "1/2")
        XCTAssertEqual(sut.imageCollectionView.numberOfItems(inSection: 0), 2)
    }
}

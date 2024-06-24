//
//  CollectionViewAdapterTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/1/15.
//

import XCTest
@testable import ListViewAdapter

class CollectionViewAdapterTests: XCTestCase {
    func testCollectionView_updateData_1Section1Cell() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let sut: CollectionViewAdapter = CollectionViewAdapter(collectionView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel()])])
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 0), 1)
    }

    func testCollectionView_updateData_1Section2Cells() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let sut: CollectionViewAdapter = CollectionViewAdapter(collectionView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel(), MockCellModel()])])
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 0), 2)
    }

    func testCollectionView_updateData_2Section1CellAnd2Cells() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let sut: CollectionViewAdapter = CollectionViewAdapter(collectionView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel()]),
                        AdapterSectionModel(items: [MockCellModel(),
                                                    MockCellModel()])])
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 1), 2)
    }

    class MockBaseCell: UICollectionViewCell {}

    class MockCellModel: AdapterItemModel {
        var type: UIView.Type {
            return MockBaseCell.self
        }
    }
}

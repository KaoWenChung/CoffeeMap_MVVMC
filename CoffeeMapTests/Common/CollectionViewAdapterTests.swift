//
//  CollectionViewAdapterTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/1/15.
//

import XCTest
@testable import CoffeeMap

class CollectionViewAdapterTests: XCTestCase {

    func testCollectionView_updateData_1Cell() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let sut: CollectionViewAdapter = CollectionViewAdapter(collectionView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel()])])
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 0), 1)
    }

    func testCollectionView_updateData_1section2Cells() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let sut: CollectionViewAdapter = CollectionViewAdapter(collectionView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel(), MockCellModel()])])
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 0), 2)
    }
    
    func testCollectionView_updateData_2section1cellAnd2Cells() {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let sut: CollectionViewAdapter = CollectionViewAdapter(collectionView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel()]), AdapterSectionModel(items: [MockCellModel(), MockCellModel()])])
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(sut.collectionView?.numberOfItems(inSection: 1), 2)
    }

    // MARK: - Helper
    /// tableview should be passed in this method because it is a weak type in TableViewAdapter, it means that it would be dealocate immediately
    func makeSUT(_ tableView: UITableView) -> TableViewAdapter {
        let sut: TableViewAdapter = TableViewAdapter(tableView)
        return sut
    }

    class MockBaseCell: UICollectionViewCell {}

    class MockCellModel: AdapterItemModel {
        var type: UIView.Type {
            return MockBaseCell.self
        }
        
    }

}

//
//  CoffeeMapTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
@testable import CoffeeMap

class TableViewAdapterTests: XCTestCase {
    func testTableView_updateData_1Section1Cell() {
        let tableView = UITableView()
        let sut: TableViewAdapter = makeSUT(tableView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel()])])
        XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 0), 1)
    }

    func testTableView_updateData_1Section2Cells() {
        let tableView = UITableView()
        let sut: TableViewAdapter = makeSUT(tableView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel(), MockCellModel()])])
        XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 0), 2)
    }

    func testTableView_updateData_2Section1CellAnd2Cells() {
        let tableView = UITableView()
        let sut: TableViewAdapter = makeSUT(tableView)
        sut.updateData([AdapterSectionModel(items: [MockCellModel()]),
                        AdapterSectionModel(items: [MockCellModel(), MockCellModel()])])
        XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 1), 2)
    }

    // MARK: - Helper
    /// tableview should be passed in this method because it is a weak type in TableViewAdapter,
    /// it means that it would be dealocate immediately
    func makeSUT(_ tableView: UITableView) -> TableViewAdapter {
        let sut: TableViewAdapter = TableViewAdapter(tableView)
        return sut
    }

    class MockBaseCell: UITableViewCell {}

    class MockCellModel: AdapterItemModel {
        var type: UIView.Type {
            return MockBaseCell.self
        }
    }
}

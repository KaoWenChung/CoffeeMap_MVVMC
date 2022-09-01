//
//  CoffeeMapTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
@testable import CoffeeMap

class TableViewAdapterTests: XCTestCase {
    func testTableView_updateData_1cell() {
        let tableView = UITableView()
        let sut: TableViewAdapter = makeSUT(tableView)
        sut.updateData([MockCellModel()])
        XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 0), 1)
    }

    func testTableView_updateData_2cell() {
        let tableView = UITableView()
        let sut: TableViewAdapter = makeSUT(tableView)
        sut.updateData([MockCellModel(), MockCellModel()])
        XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 0), 2)
    }

    // MARK: - Helper
    /// tableview should be passed in this method because it is a weak type in TableViewAdapter, it means that it would be dealocate immediately
    func makeSUT(_ tableView: UITableView) -> TableViewAdapter {
        let cell = MockBaseCell()
        let sut: TableViewAdapter = TableViewAdapter(tableView, cell: cell)
        return sut
    }

    class MockBaseCell: UITableViewCell, BaseCellView {

        func setupCellView(rowModel: BaseCellRowModel) {}

    }

    class MockCellModel: BaseCellRowModel {

        var cellID: String = "MockBaseCell"
        
        var cellAction: ((BaseCellRowModel) -> ())?
        
    }
}

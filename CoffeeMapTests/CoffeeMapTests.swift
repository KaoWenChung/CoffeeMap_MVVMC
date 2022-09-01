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
        let cell = MockBaseCell()
        let sut: TableViewAdapter = TableViewAdapter(tableView, cell: cell)
        sut.updateData([MockCellModel()])
        XCTAssertEqual(sut.tableView?.numberOfRows(inSection: 0), 1)
    }

    class MockBaseCell: UITableViewCell, BaseCellView {

        func setupCellView(rowModel: BaseCellRowModel) {}

    }

    class MockCellModel: BaseCellRowModel {

        var cellID: String = "MockBaseCell"
        
        var cellAction: ((BaseCellRowModel) -> ())?
        
    }
}

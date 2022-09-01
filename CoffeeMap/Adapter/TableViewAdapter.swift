//
//  TableViewAdapter.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

protocol BaseCellRowModel {
    var cellID: String { get set }
    var cellAction: ((BaseCellRowModel)->())? { get set }
}

class TableViewAdapter: NSObject {

    weak var tableView: UITableView?

    var rowModels: [BaseCellRowModel] = []
}

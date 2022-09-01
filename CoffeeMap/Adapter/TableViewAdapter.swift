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

protocol BaseCellView: UITableViewCell {
    func setupCellView(rowModel: BaseCellRowModel)
}

extension BaseCellView {
    var cellReuseIdentifier: String {
        return "\(type(of: self))"
    }
}

class TableViewAdapter: NSObject {

    weak var tableView: UITableView?

    private(set) var rowModels: [BaseCellRowModel] = []

    init(_ tableView: UITableView, cell: BaseCellView) {
        super.init()
        self.tableView = tableView
        self.tableView?.register(UINib(nibName: cell.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cell.cellReuseIdentifier)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }
    
    func updateData(_ rowModels: [BaseCellRowModel]) {
        self.rowModels = rowModels
        tableView?.reloadData()
    }

}

// MARK: - TableViewAdapter UITableViewDataSource
extension TableViewAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Because this is a simple project, I gave it a static property
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModels[indexPath.row].cellID, for: indexPath)
        
        if let cell = cell as? BaseCellView {
            cell.setupCellView(rowModel: rowModels[indexPath.row])
        }

        return cell
    }

}

// MARK: - TableViewAdapter UITableViewDelegate
extension TableViewAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let action = rowModels[indexPath.row].cellAction {
            action(rowModels[indexPath.row])
        }
    }

}


//
//  TableViewAdapter.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

public class TableViewAdapter: NSObject {
    public weak var tableView: UITableView?
    public weak var delegate: TableCollectionViewAdapterDelegate?
    public private(set) var sections: [AdapterSectionModel] = []
    let registerService = TableViewRegistryService()

    public init(_ tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }

    open func updateData(_ cells: [AdapterItemModel]) {
        self.sections = [AdapterSectionModel(items: cells)]
        tableView?.reloadData()
    }

    open func updateData(_ sections: [AdapterSectionModel]) {
        self.sections = sections
        tableView?.reloadData()
    }

    /// Register UITableViewCell
    open func register(_ item: UITableViewCell.Type) {
        registerService.registerCell(tableView, cellType: item)
    }
}

// MARK: - TableViewAdapter UITableViewDataSource
extension TableViewAdapter: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.type.name, for: indexPath)

        delegate?.configure(model: item, view: cell, indexPath: indexPath)

        return cell
    }
}

// MARK: - TableViewAdapter UITableViewDelegate
extension TableViewAdapter: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        delegate?.select(model: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        let cgSize = delegate?.size(model: item, containerSize: tableView.frame.size)

        return cgSize?.height ?? 0
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = sections[section].header,
              let cgSize = delegate?.size(model: header, containerSize: tableView.frame.size) else { return 0 }

        return cgSize.height
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = sections[section].footer,
              let cgSize = delegate?.size(model: footer, containerSize: tableView.frame.size) else { return 0 }

        return cgSize.height
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = sections[section].header,
              let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.type.name) else { return nil }
        delegate?.configure(model: header, view: view, indexPath: IndexPath(row: 0, section: section))

        return view
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = sections[section].footer,
              let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.type.name) else { return nil }
        delegate?.configure(model: footer, view: view, indexPath: IndexPath(row: 0, section: section))

        return view
    }
}

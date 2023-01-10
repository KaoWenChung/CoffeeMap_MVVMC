//
//  RegisterService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/5.
//

import UIKit

public class TableViewRegistryService {
    public private(set) var registeredTypes = Set<String>()

    public func registerCell(_ tableView: UITableView?, cellType: UITableViewCell.Type) {
        if !registeredTypes.contains("\(cellType)") {
            tableView?.register(UINib(nibName: "\(cellType)", bundle: nil), forCellReuseIdentifier: "\(cellType)")
        }
    }
    public func registerCell(_ tableView: UITableView?, item: AdapterItemModel) {
        if !registeredTypes.contains(item.type.name) {
            if item.type.isSubclass(of: UITableViewCell.self) {
                tableView?.register(UINib(nibName: item.type.name, bundle: nil), forCellReuseIdentifier: item.type.name)
            }
            registeredTypes.insert(item.type.name)
        }
    }

    public func registerHeaderFooter(_ tableView: UITableView?, item: AdapterItemModel) {
        if item.type.isSubclass(of: UITableViewHeaderFooterView.self) {
            tableView?.register(item.type, forHeaderFooterViewReuseIdentifier: item.type.name)
        }
        registeredTypes.insert(item.type.name)
    }
    /// For in loop to register all views in the sections
    public func registerIfNeeded(_ tableView: UITableView?, sections: [AdapterSectionModel]) {
        sections.forEach { section in
            if let header = section.header, !registeredTypes.contains(header.type.name) {
                registerHeaderFooter(tableView, item: header)
            }
            if let footer = section.footer, !registeredTypes.contains(footer.type.name) {
                registerHeaderFooter(tableView, item: footer)
            }
            section.items.forEach { item in
                registerCell(tableView, item: item)
            }
        }
    }
}

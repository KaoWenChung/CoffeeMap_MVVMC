//
//  RegisterService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/5.
//

import UIKit

public class TableViewRegistryService {
    public private(set) var registeredTypes = Set<String>()

    func registerIfNeeded(_ tableView: UITableView?, sections: [AdapterSectionModel]) {
        sections.forEach { section in
            if let header = section.header, !registeredTypes.contains(header.type.name) {

                if header.type.isSubclass(of: UITableViewHeaderFooterView.self) {
                    tableView?.register(header.type, forHeaderFooterViewReuseIdentifier: header.type.name)
                }

                registeredTypes.insert(header.type.name)
            }

            if let footer = section.footer, !registeredTypes.contains(footer.type.name) {

                if footer.type.isSubclass(of: UITableViewHeaderFooterView.self) {
                    tableView?.register(footer.type, forHeaderFooterViewReuseIdentifier: footer.type.name)
                }

                registeredTypes.insert(footer.type.name)
            }

            section.items.forEach { item in
                
                if !registeredTypes.contains(item.type.name) {

                    if item.type.isSubclass(of: UITableViewCell.self) {
                        tableView?.register(UINib(nibName: item.type.name, bundle: nil), forCellReuseIdentifier: item.type.name)
                    }

                    registeredTypes.insert(item.type.name)
                }
            }
        }
    }
}

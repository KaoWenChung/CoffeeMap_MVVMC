//
//  CollectionViewRegistryService.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

public class CollectionViewRegistryService {
    public private(set) var registeredTypes = Set<String>()

    public func registerCell(_ collectionView: UICollectionView, cellType: UICollectionViewCell.Type) {
        if !registeredTypes.contains("\(cellType)") {
            collectionView.register(UINib(nibName: "\(cellType)", bundle: nil),
                                    forCellWithReuseIdentifier: "\(cellType)")
        }
    }

    public func registerCell(_ collectionView: UICollectionView, item: AdapterItemModel) {
        if !registeredTypes.contains(item.type.name) {
            if item.type.isSubclass(of: UITableViewCell.self) {
                collectionView.register(UINib(nibName: item.type.name, bundle: nil),
                                        forCellWithReuseIdentifier: item.type.name)
            }
            registeredTypes.insert(item.type.name)
        }
    }

    public func registerHeaderFooter(_ collectionView: UICollectionView, item: AdapterItemModel) {
        if item.type.isSubclass(of: UICollectionReusableView.self) {
            collectionView.register(item.type,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: item.type.name)
        }
        registeredTypes.insert(item.type.name)
    }
    /// For in loop to register all views in the sections
    public func registerIfNeeded(_ collectionView: UICollectionView, sections: [AdapterSectionModel]) {
        sections.forEach { section in
            if let header = section.header, !registeredTypes.contains(header.type.name) {
                registerHeaderFooter(collectionView, item: header)
            }
            if let footer = section.footer, !registeredTypes.contains(footer.type.name) {
                registerHeaderFooter(collectionView, item: footer)
            }
            section.items.forEach { item in
                registerCell(collectionView, item: item)
            }
        }
    }
}

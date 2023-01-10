//
//  CollectionViewAdapter.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

public class CollectionViewAdapter: NSObject {
    public weak var collectionView: UICollectionView?
    public weak var delegate: TableCollectionViewAdapterDelegate?
    public private(set) var sections: [AdapterSectionModel] = []
    let registerService = CollectionViewRegistryService()
    
    public init(_ collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
    
    open func updateData(_ cells: [AdapterItemModel]) {
        self.sections = [AdapterSectionModel(items: cells)]
        collectionView?.reloadData()
    }

    open func updateData(_ sections: [AdapterSectionModel]) {
        self.sections = sections
        collectionView?.reloadData()
    }

    /// Register UICollectionViewCell
    open func register(_ item: UICollectionViewCell.Type) {
        guard let collectionView else { return }
        registerService.registerCell(collectionView, cellType: item)
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewAdapter: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.type.name, for: indexPath)

        delegate?.configure(model: item, view: cell, indexPath: indexPath)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewAdapter: UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        delegate?.select(model: item)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].items[indexPath.row]
        if let size = delegate?.size(model: item, containerSize: collectionView.frame.size) {
          return size
        }

        if let size = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize {
          return size
        }

        return collectionView.frame.size
    }

    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let header = sections[section].header else {
          return .zero
        }

        guard let size = delegate?.size(model: header, containerSize: collectionView.frame.size) else {
          return .zero
        }

        return size
    }

    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let footer = sections[section].footer else {
          return .zero
        }

        guard let size = delegate?.size(model: footer, containerSize: collectionView.frame.size) else {
          return .zero
        }

        return size
    }
}

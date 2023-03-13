//
//  AdapterSectionModel.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/5.
//

/// Section
public struct AdapterSectionModel {
    /// Rows
    public let items: [AdapterItemModel]
    public let header: AdapterItemModel?
    public let footer: AdapterItemModel?

    public init(items: [AdapterItemModel], header: AdapterItemModel? = nil, footer: AdapterItemModel? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}

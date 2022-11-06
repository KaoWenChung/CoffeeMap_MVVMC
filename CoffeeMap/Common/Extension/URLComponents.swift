//
//  URLComponents.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/5.
//

import Foundation

extension URLComponents {

    mutating func setQueryItemsBy(dictionary: [String: Any]) {
        var _queryItems: [URLQueryItem] = []
        for item in dictionary {
            _queryItems.append(URLQueryItem(name: item.key, value: String(describing: item.value)))
        }
        queryItems = _queryItems
    }

}

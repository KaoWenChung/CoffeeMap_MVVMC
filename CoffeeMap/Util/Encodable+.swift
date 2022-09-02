//
//  Encodable+.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

extension Encodable {
    /// Sweeter: Export object to a dictionary representation
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }

}

extension URLComponents {

    mutating func addQueryItemsBy(dictionary: [String: Any]) {
        var _queryItems: [URLQueryItem] = []
        for item in dictionary {
            _queryItems.append(URLQueryItem(name: item.key, value: String(describing: item.value)))
        }
        queryItems = _queryItems
    }

}

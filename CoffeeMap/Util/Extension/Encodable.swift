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


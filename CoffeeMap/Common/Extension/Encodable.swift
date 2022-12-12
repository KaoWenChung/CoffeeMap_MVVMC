//
//  Encodable+.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

extension Encodable {
    /// Sweeter: Export object to a dictionary representation
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}

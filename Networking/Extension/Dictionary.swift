//
//  Dictionary.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/12.
//

import Foundation

extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

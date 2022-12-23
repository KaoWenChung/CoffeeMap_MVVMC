//
//  CafeDetailRequestDTO+Mapping.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/23.
//

import Foundation

struct CafeDetailRequestDTO: Encodable {
    let fsqid: String

    enum CodingKeys: String, CodingKey {
        case fsqid = "fsq_id"
    }
}

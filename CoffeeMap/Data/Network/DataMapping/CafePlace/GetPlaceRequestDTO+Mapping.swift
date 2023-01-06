//
//  GetPlaceRequestDTO+Mapping.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/12.
//

class CafePlaceRequestDTO: Encodable {
    var ll: String?
    var radius: Int?
    var query: String?
    var sort: String?
    var openNow: Bool?
    var cursor: String?

    enum CodingKeys: String, CodingKey {
        case ll
        case radius
        case query
        case sort
        case openNow = "open_now"
        case cursor
    }
}

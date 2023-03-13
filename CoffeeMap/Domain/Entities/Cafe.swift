//
//  Cafe.swift
//  CoffeeMap
//
//  Created by wyn on 2023/3/12.
//

struct Cafe {
    /// The distance (in meters) from the provided location (i.e. ll + radius OR near OR ne + sw) in the API call.
    /// This field will only be returned by the Place Search endpoint.
    let distance: Int?
    /// A unique identifier for a FSQ Place (formerly known as Venue ID).
    let fsqId: String?
    let name: String?
    let formattedAddress: String?
    let latitude: Double?
    let longitude: Double?
    let description: String?
}

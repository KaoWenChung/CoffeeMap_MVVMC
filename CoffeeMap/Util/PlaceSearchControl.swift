//
//  PlaceSearchControl.swift
//  CoffeeMap
//
//  Created by wyn on 2022/9/25.
//

class PlaceSearchControl {
    static func convertCoordinate(latitude: Double, longitude: Double) -> String {
        return String(latitude) + "," + String(longitude)
    }
}

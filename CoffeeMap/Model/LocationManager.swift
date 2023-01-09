//
//  LocationManager.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation
import CoreLocation

protocol LocationManager {
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
    // CLLocationManager Methods
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationManager {}


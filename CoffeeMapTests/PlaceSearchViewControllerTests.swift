//
//  PlaceSearchViewControllerTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
import CoreLocation
@testable import CoffeeMap

class PlaceSearchViewControllerTests: XCTestCase {
    
    
    class MockLocationManager: LocationManager {

        func requestLocation() {}
        
        func requestWhenInUseAuthorization() {}
        
        var delegate: CLLocationManagerDelegate?

        var location: CLLocation? = CLLocation(
            latitude: 51.50998,
            longitude: -0.1337
        )
    }

}

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

    func testViewDidload_requestedAuthorizationSuccessfully() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewController(PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel)), locationManager: SuccessdingMockLocationManager())
        XCTAssertEqual(sut.locationManager?.location?.coordinate.longitude, -0.1337)
        XCTAssertEqual(sut.locationManager?.location?.coordinate.latitude, 51.50998)
    }

    func testViewDidload_requestedAuthorizationFailure() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewController(PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel)), locationManager: FailingMockLocationManager())
        XCTAssertEqual(sut.locationManager?.location, nil)
    }
    
    class SuccessdingMockLocationManager: LocationManager {

        func requestLocation() {}
        
        func requestWhenInUseAuthorization() {}
        
        var delegate: CLLocationManagerDelegate?

        var location: CLLocation? = CLLocation(
            latitude: 51.50998,
            longitude: -0.1337
        )
    }
    
    class FailingMockLocationManager: LocationManager {

        func requestLocation() {}
        
        func requestWhenInUseAuthorization() {}
        
        var delegate: CLLocationManagerDelegate?

        var location: CLLocation? = nil
    }
}

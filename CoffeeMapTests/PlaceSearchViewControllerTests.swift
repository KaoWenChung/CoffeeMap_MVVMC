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
        let sut = try makeSUT()
        XCTAssertEqual(sut.locationManager?.location?.coordinate.longitude, -0.1337)
        XCTAssertEqual(sut.locationManager?.location?.coordinate.latitude, 51.50998)
    }

    func testViewDidload_() throws {
        let sut = try makeSUT()
        let expectation = self.expectation(description: "fetchData")
        _ = sut.view
        sut.fetchData() { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch data fail with error: \(error.message)")
            }
        }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 10)
    }

    func testViewDidload_requestedAuthorizationFailure() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewController(PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel)), locationManager: FailingMockLocationManager())
        XCTAssertEqual(sut.locationManager?.location, nil)
    }

    private func makeSUT() throws -> PlaceSearchViewController {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewController(PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel)), locationManager: SuccessdingMockLocationManager())
        return sut
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

private extension UITableView {

    func placeSearchCell(at row: Int) -> PlaceSearchTableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0)) as? PlaceSearchTableViewCell
    }

}

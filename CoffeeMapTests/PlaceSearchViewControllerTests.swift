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
        let sut = try makeSUTWithLocation()
        XCTAssertEqual(sut.locationManager?.location?.coordinate.longitude, -0.1337)
        XCTAssertEqual(sut.locationManager?.location?.coordinate.latitude, 51.50998)
    }

    func testViewDidload_tableViewHasCells() throws {
        let sut = try makeSUTWithLocation()
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
        XCTAssertEqual(sut.tableView.isHidden, false)
        XCTAssertEqual(sut.noResultLabel.isHidden, true)
    }

    func testViewDidload_firstTableViewCell() throws {
        let sut = try makeSUTWithLocation()
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
        XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.nameLabel.text, "Caffè Concerto")
        XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.addressLabel.text, "45 Haymarket, London, Greater London, SW1Y 4SE")
        XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.distanceLabel.text, "39 meters")
    }

    func testViewDidload_tableViewHasNoCells() throws {
        let sut = try makeSUTWithoutLocation()
        let expectation = self.expectation(description: "fetchData")
        _ = sut.view
        sut.fetchData() { result in
            switch result {
            case .success:
                XCTFail("Should not fetch any data")
            case .failure(let error):
                XCTAssertEqual(error.message, "Unable to get user's location")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(sut.tableView.isHidden, true)
        XCTAssertEqual(sut.noResultLabel.isHidden, false)
    }

    func testViewDidload_requestedAuthorizationFailure() throws {
        let sut = try makeSUTWithoutLocation()
        XCTAssertEqual(sut.locationManager?.location, nil)
    }

    private func makeSUTWithLocation() throws -> PlaceSearchViewController {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewController(PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel)), locationManager: SuccessdingMockLocationManager())
        return sut
    }

    private func makeSUTWithoutLocation() throws -> PlaceSearchViewController {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewController(PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel)), locationManager: FailingMockLocationManager())
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

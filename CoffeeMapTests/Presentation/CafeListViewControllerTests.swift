//
//  PlaceSearchViewControllerTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
import CoreLocation
@testable import CoffeeMap

final class CafeListViewControllerTests: XCTestCase {
    func testViewDidload_requestedAuthorizationSuccessfully() throws {
        let location = makeCLLocation()
        let sut = try makeSUTWithLocation(location)
        XCTAssertEqual(sut.locationManager?.location?.coordinate.longitude, -0.1337)
        XCTAssertEqual(sut.locationManager?.location?.coordinate.latitude, 51.50998)
    }

    @MainActor
    func testViewDidload_tableViewHasCells() async throws {
        let location = makeCLLocation()
        let sut = try makeSUTWithLocation(location)
        await sut.fetchDataByLocation()
        XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.nameLabel.text, "Mock 1")
        XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.addressLabel.text, "Mock address")
        XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.distanceLabel.text, "39 meters")
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
        XCTAssertEqual(sut.tableView.isHidden, false)
        XCTAssertEqual(sut.noResultLabel.isHidden, true)
    }

    @MainActor
    func testViewDidload_tableViewHasNoCells() async throws {
        let sut = try makeSUTWithLocation(nil)
        XCTAssertEqual(sut.locationManager?.location, nil)
        await sut.fetchDataByLocation()
        XCTAssertEqual(sut.tableView.isHidden, true)
        XCTAssertEqual(sut.noResultLabel.isHidden, false)
    }

    // MARK: - Helper
    private func makeSUTWithLocation(_ location: CLLocation?) throws -> CafeListViewController {
        let getplaceDataModel = CafePlaceResponseDTO.stub(results: [GetPlaceResultDTO.stub(name: "Mock 1",
                                                                                           address: "Mock address",
                                                                                           distance: 39)])
        var response: [CafeTableViewCellModel] = []
        for result in getplaceDataModel.results ?? [] {
            response.append(CafeTableViewCellModel(result.toEntity(), photoModel: []))
        }
        let cafeListModel = CafeListModel(cursor: nil, cafeList: response)
        let searchCafeUseCase = SearchCafeUseCaseMock(cafeListModel: cafeListModel,
                                                      error: nil,
                                                      expectation: nil)
        let mockViewModel = CafeListViewModel(searchCafeUseCase: searchCafeUseCase,
                                              actions: nil)
        let sut = CafeListViewController(mockViewModel,
                                         locationManager: LocationManagerMock(location: location),
                                         imageRepository: ImageRepositoryMock(response: nil,
                                                                              error: nil,
                                                                              expectation: nil))
        return sut
    }

    func makeCLLocation() -> CLLocation {
        let latitude = 51.50998
        let longitude = -0.1337
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    class LocationManagerMock: LocationManager {
        func requestLocation() {}
        func requestWhenInUseAuthorization() {}
        var delegate: CLLocationManagerDelegate?
        var location: CLLocation?
        init(location: CLLocation?) {
            self.location = location
        }
    }

}

private extension UITableView {
    func placeSearchCell(at row: Int) -> CafeTableViewCell? {
        guard dataSource?.tableView(self, numberOfRowsInSection: 0) ?? 0 > row else { return nil }
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0)) as? CafeTableViewCell
    }
}

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

    func testViewDidload_tableViewHasCells() throws {
        let location = makeCLLocation()
        let sut = try makeSUTWithLocation(location)
        Task.init {
            await sut.fetchDataByLocation()
            DispatchQueue.main.async {
                XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 10)
                XCTAssertEqual(sut.tableView.isHidden, false)
                XCTAssertEqual(sut.noResultLabel.isHidden, true)
            }
        }
    }

    func testViewDidload_firstTableViewCell() throws {
        let location = makeCLLocation()
        let sut = try makeSUTWithLocation(location)
        Task.init {
            await sut.fetchDataByLocation()
            DispatchQueue.main.async {
                XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.nameLabel.text, "Caffè Concerto")
                XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.addressLabel.text, "45 Haymarket, London, Greater London, SW1Y 4SE")
                XCTAssertEqual(sut.tableView.placeSearchCell(at: 0)?.distanceLabel.text, "39 meters")
            }
        }
    }

    func testViewDidload_tableViewHasNoCells() throws {
        let sut = try makeSUTWithLocation(nil)
        XCTAssertEqual(sut.locationManager?.location, nil)
        Task.init {
            await sut.fetchDataByLocation()
            DispatchQueue.main.async {
                XCTAssertEqual(sut.tableView.isHidden, true)
                XCTAssertEqual(sut.noResultLabel.isHidden, false)
            }
        }
    }

    // MARK: - Helper
    private func makeSUTWithLocation(_ location: CLLocation?) throws -> CafeListViewController {
        let getplaceDataModel: CafePlaceResponseDTO = try fetchStubModel(fileName: "GetPlace_London")
        var response: [CafeTableViewCellModel] = []
        for result in getplaceDataModel.results ?? [] {
            response.append(CafeTableViewCellModel(result, photoModel: []))
        }
        let cafeListModel = CafeListModel(cursor: nil, cafeList: response)
        let mockViewModel = CafeListViewModel(searchCafeUseCase: SearchCafeUseCaseMock(cafeListModel: cafeListModel, error: nil, expectation: nil), actions: nil)
        let sut = CafeListViewController(mockViewModel, locationManager: LocationManagerMock(location: location), imageRepository: ImageRepositoryMock(response: nil, error: nil, expectation: nil))
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
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0)) as? CafeTableViewCell
    }

}

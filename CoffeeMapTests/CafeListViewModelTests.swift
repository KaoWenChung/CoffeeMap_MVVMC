//
//  PlaceSearchViewModelTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
@testable import CoffeeMap

class CafeListViewModelTests: XCTestCase {

    func testPostListUseCaseWithNetwokError() async {
        let expectation = expectation(description: "Should run error")
        let error = NetworkError.notConnected
        let sut = CafeListViewModel(searchCafeUseCase: SearchCafeUseCaseMock(response: [],error: error, expectation: expectation), actions: nil)
        let ll = "0,0"
        await sut.fetchData(ll: ll)
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(sut.error)
    }

    func testGetSortedGetPlaceResult_StubLondonData() async throws {
        let expectation = expectation(description: "Should get data")
        let getplaceDataModel: CafePlaceResponseDTO = try fetchStubModel(fileName: "GetPlace_London")
        
        let sut = CafeListViewModel(searchCafeUseCase: SearchCafeUseCaseMock(response: getplaceDataModel.toDomain(),error: nil, expectation: expectation), actions: nil)
        
        await sut.fetchData(ll: "51.50998,-0.1337")
        let items = sut.placeList.value.first?.items

        if let items = items as? [CafeListTableViewCellModel] {
            XCTAssertEqual(items.count, 10)
            XCTAssertEqual(items.first?.name, "Caffè Concerto")
            XCTAssertEqual(items.last?.name, "Piggy's")
        } else {
            XCTFail("Should not happen")
        }
        wait(for: [expectation], timeout: 0.1)
    }

}

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
        let sut = CafeListViewModel(searchCafeUseCase: SearchCafeUseCaseMock(cafeListModel: CafeListModel(cursor: nil, cafeList: []),error: error, expectation: expectation), actions: nil)
        let ll = "0,0"
        await sut.fetchDataBy(ll: ll)
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(sut.error)
    }

    func testGetSortedGetPlaceResult_StubLondonData() async throws {
        let expectation = expectation(description: "Should get data")
        let getplaceDataModel: CafePlaceResponseDTO = try fetchStubModel(fileName: "GetPlace_London")
        var response: [CafeTableViewCellModel] = []
        for result in getplaceDataModel.results ?? [] {
            response.append(CafeTableViewCellModel(result, photoModel: []))
        }
        let cafelistModel = CafeListModel(cursor: nil, cafeList: response)
        let sut = CafeListViewModel(searchCafeUseCase: SearchCafeUseCaseMock(cafeListModel: cafelistModel, error: nil, expectation: expectation), actions: nil)
        await sut.fetchDataBy(ll: "51.50998,-0.1337")
        let items = sut.placeList.value
        XCTAssertEqual(items.count, 10)
        XCTAssertEqual(items.first?.name, "Caffè Concerto")
        XCTAssertEqual(items.last?.name, "Piggy's")
        wait(for: [expectation], timeout: 0.1)
    }

}

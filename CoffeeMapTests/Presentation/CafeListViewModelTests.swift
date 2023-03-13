//
//  PlaceSearchViewModelTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
@testable import CoffeeMap

final class CafeListViewModelTests: XCTestCase {
    func testPostListUseCaseWithNetwokError() async {
        // given
        let expectation = expectation(description: "Should run error")
        let error = NetworkError.notConnected
        let searchCafeUseCase = SearchCafeUseCaseMock(cafeListModel: CafeListModel(cursor: nil, cafeList: []),
                                                      error: error,
                                                      expectation: expectation)
        let sut = CafeListViewModel(searchCafeUseCase: searchCafeUseCase,
                                    actions: nil)
        let latitudeLongitude = "0,0"
        // when
        await sut.fetchDataBy(latitudeLongitude: latitudeLongitude)
        // then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(sut.error)
    }

    func testGetSortedGetPlaceResult_StubLondonData() async throws {
        // given
        let expectation = expectation(description: "Should get data")
        let getplaceDataModel = CafePlaceResponseDTO.stub(results: [
            GetPlaceResultDTO.stub(name: "Mock 1"),
            GetPlaceResultDTO.stub(name: "Mock 2")]
        )
        var response: [CafeTableViewCellModel] = []
        for result in getplaceDataModel.results ?? [] {
            response.append(CafeTableViewCellModel(result.toEntity(), photoModel: []))
        }
        let cafelistModel = CafeListModel(cursor: nil, cafeList: response)
        let searchCafeUseCase = SearchCafeUseCaseMock(cafeListModel: cafelistModel,
                                                      error: nil,
                                                      expectation: expectation)
        let sut = CafeListViewModel(searchCafeUseCase: searchCafeUseCase, actions: nil)
        // when
        await sut.fetchDataBy(latitudeLongitude: "51.50998,-0.1337")
        let items = sut.placeList.value
        // then
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items.first?.name, "Mock 1")
        XCTAssertEqual(items.last?.name, "Mock 2")
        wait(for: [expectation], timeout: 0.1)
    }
}

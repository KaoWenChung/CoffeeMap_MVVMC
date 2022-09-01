//
//  PlaceSearchViewModelTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
@testable import CoffeeMap

class PlaceSearchViewModelTests: XCTestCase {
    func testgetPlaceListBy_StubLondonData() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel))
        let result = sut.getPlaceListBy(getplaceDataModel)
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(result.first?.title, "Caffè Concerto")
        XCTAssertEqual(result.last?.title, "Piggy's")
    }

    class SuccessdingFoursquareRepositoryStub: FoursquareRepositoryDelegate {
        let response: GetPlaceResponseModel
        init(_ data: GetPlaceResponseModel) {
            response = data
        }
        func getPlace(param: GetPlaceParamModel, completion: @escaping ((Result<GetPlaceResponseModel>) -> Void)) {
            completion(.success(response))
        }
    }

    class FailingFoursquareRepositoryStub: FoursquareRepositoryDelegate {
        func getPlace(param: GetPlaceParamModel, completion: @escaping ((Result<GetPlaceResponseModel>) -> Void)) {
            completion(.failure(CustomError("Something wrong")))
        }
    }
}

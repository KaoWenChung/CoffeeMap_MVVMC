//
//  PlaceSearchViewModelTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
@testable import CoffeeMap

class PlaceSearchViewModelTests: XCTestCase {

    func testGetSortedGetPlaceResult_StubLondonData() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = CafeListViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel))
        let result = sut.getSortedGetPlaceResult(getplaceDataModel)
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(result.first?.name, "Caffè Concerto")
        XCTAssertEqual(result.last?.name, "Cafe Royale")
    }

    func testGetPlaceListBy_StubLondonData() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = CafeListViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel))
        let result = sut.getPlaceListBy(getplaceDataModel.results ?? [])
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(result.first?.name, "Caffè Concerto")
        XCTAssertEqual(result.last?.name, "Piggy's")
        
    }

    func testFetchData_london_error() throws {
        let sut = CafeListViewModel(FailingFoursquareRepositoryStub())
        sut.fetchData(coordinate: "51.50998,-0.1337") { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error.message, "Something wrong")
            }
            XCTAssertEqual(sut.placeList.count, 0)
        }
    }

}

class SuccessdingFoursquareRepositoryStub: FoursquareRepositoryDelegate {

    let response: GetPlaceResponseModel
    init(_ data: GetPlaceResponseModel) {
        response = data
    }
    func getPlace(param: GetPlaceParamModel, completion: ((Result<GetPlaceResponseModel>) -> Void)?) {
        completion?(.success(response))
    }

}

class FailingFoursquareRepositoryStub: FoursquareRepositoryDelegate {

    func getPlace(param: GetPlaceParamModel, completion: ((Result<GetPlaceResponseModel>) -> Void)?) {
        completion?(.failure(CustomError("Something wrong")))
    }

}

//
//  PlaceSearchViewModelTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest
@testable import CoffeeMap

class PlaceSearchViewModelTests: XCTestCase {
    func testGetPlaceListBy_StubLondonData() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel))
        let result = sut.getPlaceListBy(getplaceDataModel)
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(result.first?.name, "Caffè Concerto")
        XCTAssertEqual(result.last?.name, "Piggy's")
    }

    func testFetchData_london_successeding() throws {
        let getplaceDataModel: GetPlaceResponseModel = try fetchStubModel(fileName: "GetPlace_London")
        let sut = PlaceSearchViewModel(SuccessdingFoursquareRepositoryStub(getplaceDataModel))
        sut.fetchData(ll: "51.50998,-0.1337") { result in
            XCTAssertEqual(sut.placeList.count, 10)
            XCTAssertEqual(sut.placeList.first?.name, "Caffè Concerto")
            XCTAssertEqual(sut.placeList.last?.name, "Piggy's")
        }
    }

    func testFetchData_london_error() throws {
        let sut = PlaceSearchViewModel(FailingFoursquareRepositoryStub())
        sut.fetchData(ll: "51.50998,-0.1337") { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error.message, "Something wrong")
            }
            XCTAssertEqual(sut.placeList.count, 0)
        }
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

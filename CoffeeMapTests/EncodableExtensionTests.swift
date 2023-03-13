//
//  EncodableExtensionTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/02.
//

import XCTest
@testable import CoffeeMap

class EncodableExtensionTests: XCTestCase {
    func testDictionary_londonParameters() throws {
        let sut = GetPlaceParamModel(latitudeLongitude: "51.50998,-0.1337", radius: 200, query: "coffee")
        let result = try sut.toDictionary()
        XCTAssertEqual(result?.count, 3)
        XCTAssertEqual(result?["ll"] as? String, "51.50998,-0.1337")
        XCTAssertEqual(result?["radius"] as? Int, 200)
        XCTAssertEqual(result?["query"] as? String, "coffee")
    }

    func testDictionary_noParameters() throws {
        let sut = GetPlaceParamModel(latitudeLongitude: nil, radius: nil, query: nil)
        let result = try sut.toDictionary()
        XCTAssertEqual(result?.count, 0)
    }
}

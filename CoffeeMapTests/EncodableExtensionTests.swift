//
//  EncodableExtensionTests.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/02.
//

import XCTest
import CoreLocation
@testable import CoffeeMap

class EncodableExtensionTests: XCTestCase {

    func testDictionary_londonParameters() throws {
        let sut = GetPlaceParamModel(ll: "51.50998,-0.1337", radius: 200, query: "coffee")
        let result = sut.dictionary
        XCTAssertEqual(result?.count, 3)
        XCTAssertEqual(result?["ll"] as? String, "51.50998,-0.1337")
        XCTAssertEqual(result?["radius"] as? Int, 200)
        XCTAssertEqual(result?["query"] as? String, "coffee")
    }

}

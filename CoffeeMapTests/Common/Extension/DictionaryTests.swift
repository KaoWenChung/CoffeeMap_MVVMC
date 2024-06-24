//
//  DictionaryTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/1/15.
//

import XCTest
@testable import Networking

final class DictionaryTests: XCTestCase {
    func testQueryString_intStringDouble() throws {
        let test: [String: Any] = ["int": 0,
                    "string": "String",
                    "double": 0.0001]
        let sut = test.queryString
        XCTAssertTrue(sut.contains("double=0.0001"))
        XCTAssertTrue(sut.contains("int=0"))
        XCTAssertTrue(sut.contains("string=String"))
    }
}

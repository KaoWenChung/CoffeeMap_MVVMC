//
//  String.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/1/12.
//

import XCTest
@testable import CoffeeMap

final class StringTests: XCTestCase {
    func testToDate_dateWithTime_newYearOf2023() {
        let dateString = "2023/01/01 00:00:00"
        let dateFormat = "yyyy/MM/dd HH:mm:ss"
        let sut = makeSUT(dateString: dateString, dateFormat: dateFormat)
        // "2023/01/01 00:00:00"
        let newYear: Date = Date(timeIntervalSince1970: 1672531200)
        XCTAssertEqual(sut, newYear)
    }
    func testToDate_date_newYearOf2023() {
        let dateString = "2023/01/01"
        let dateFormat = "yyyy/MM/dd"
        let sut = makeSUT(dateString: dateString, dateFormat: dateFormat)
        // "2023/01/01 00:00:00"
        let newYear: Date = Date(timeIntervalSince1970: 1672531200)
        XCTAssertEqual(sut, newYear)
    }
    func testToDate_errorString_nil() {
        let dateString = "errorString"
        let dateFormat = "yyyy/MM/dd"
        let sut = makeSUT(dateString: dateString, dateFormat: dateFormat)
        XCTAssertEqual(sut, nil)
    }
    func testToDate_errorFormat_nil() {
        let dateString = "2023/01/01"
        let dateFormat = "testToDate_errorFormat_nil"
        let sut = makeSUT(dateString: dateString, dateFormat: dateFormat)
        XCTAssertEqual(sut, nil)
    }
    // MARK: - Helper
    private func makeSUT(dateString: String, dateFormat: String) -> Date? {
        let dateString = dateString
        let locale = Locale(identifier: "en_GB")
        let timeZone = TimeZone(identifier: "Europe/London")
        let result = dateString.toDate(dateFormat: dateFormat, locale: locale, timeZone: timeZone)
        return result
    }
}

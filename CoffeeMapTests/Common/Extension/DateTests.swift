//
//  DateTests.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/1/12.
//

import XCTest
@testable import CoffeeMap

final class DateTests: XCTestCase {
    func testToString_theFirstDateOf2023_dateWithTime() {
        let sut = makeSUT(dateFormat: "yyyy/MM/dd HH:mm:ss")
        XCTAssertEqual(sut, "2023/01/01 00:00:00")
    }
    func testToString_theFirstDateOf2023_date() {
        let result = makeSUT(dateFormat: "yyyy/MM/dd")
        XCTAssertEqual(result, "2023/01/01")
    }
    // MARK: - Helper
    private func makeSUT(dateFormat: String) -> String {
        // given
        // "2023/01/01 00:00:00"
        let sut: Date = Date(timeIntervalSince1970: 1672531200)
        let dateFormat = dateFormat
        let locale = Locale(identifier: "en_GB")
        let timeZone = TimeZone(identifier: "Europe/London")
        // when
        let result = sut.toString(dateFormat: dateFormat, locale: locale, timeZone: timeZone)
        return result
    }
}

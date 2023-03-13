//
//  XCTestCase+.swift
//  CoffeeMapTests
//
//  Created by owenkao on 2022/09/01.
//

import XCTest

extension XCTestCase {
    enum ErrorMock: Error {
        case someError
    }
    func loadStub(name aName: String, extension aExtension: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: aName, withExtension: aExtension)
      return try? Data(contentsOf: url!)
    }

    func fetchStubModel<T: Decodable>(fileName aFileName: String) throws -> T {
        guard let data = loadStub(name: aFileName, extension: "json") else { throw ErrorMock.someError }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let decodableData = try decoder.decode(T.self, from: data)
        return decodableData
    }
}

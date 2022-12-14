//
//  ConnectionError.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/14.
//

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}

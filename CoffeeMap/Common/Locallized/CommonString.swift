//
//  CommonString.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/14.
//

enum CommonString: LocallizedStringType {
    case error
    case ok
    case cancel
}

enum ErrorString: LocallizedStringType {
    /// No internet connection
    case noInternet
    /// Failed loading cafe data
    case failLoadingCafe
    /// Unable to get user's location
    case failGetLocation
}

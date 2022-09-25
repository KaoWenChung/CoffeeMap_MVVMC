//
//  BaseViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

struct CustomError: Error {

    var message: String = ""

    init(_ message: String) {
        self.message = message
    }

}

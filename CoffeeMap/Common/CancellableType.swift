//
//  CancellableType.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/6.
//

public protocol CancellableType {
    func cancel()
}

extension Task: CancellableType {}

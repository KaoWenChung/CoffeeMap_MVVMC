//
//  Result.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/10.
//


enum Result<Value> {

    case success(Value)
    case failure(CustomError)

}

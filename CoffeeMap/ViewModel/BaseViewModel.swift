//
//  BaseViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2022/9/25.
//

class BaseViewModel {

    typealias Completion = (_ result: CompletionResult) -> Void

    enum CompletionResult {
        case success
        case failure(CustomError)
    }

}

//
//  RepositoryTask.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/7.
//

final class RepositoryTask: CancellableType {
    var networkTask: URLTask?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}


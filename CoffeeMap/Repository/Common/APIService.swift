//
//  APIService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/11.
//

import Foundation

protocol APIService {

    func request<T: Decodable>(request: URLRequest, completion: ((Result<T>) -> Void)?)

}

//
//  APIService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/11.
//

import Foundation

protocol APIServiceType {

    func request<T: Decodable>(request: URLRequest) async throws -> T

}

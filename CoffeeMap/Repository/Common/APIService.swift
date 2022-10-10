//
//  APIService.swift
//  CoffeeMap
//
//  Created by wyn on 2022/10/10.
//

import Foundation

protocol APIService {
    func get<T: Decodable>(url: URL, completion: ((Result<T>) -> Void)?)
}

//
//  BaseRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

enum Result<Value> {

    case success(Value)
    case failure(CustomError)

}

class BaseRepository {
    // TODO: ADD API KEY HERE
    private let apiKey: String = ""

    private var headers: [String: String] {
        return [
            "Accept": "application/json",
            "Authorization": apiKey
          ]
    }
    
    func get<T: Decodable>(url: URL, completion: @escaping ((Result<T>) -> Void)) {
        let urlRequest = NSMutableURLRequest(url: url,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers

        request(request: urlRequest as URLRequest, completion: completion)
    }

    private func request<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T>) -> Void)) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            // Handle Error
            if let error = error {
                completion(.failure(CustomError(error.localizedDescription)))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // Handle Empty Response
                completion(.failure(CustomError("Empty Response")))
                print("Empty Response")
                return
            }
            guard let _data = data else {
                // Handle Empty Data
                completion(.failure(CustomError("Empty Data")))
                print("Empty Data")
                return
            }
            do {
                // Parse the data
                let deconder = JSONDecoder()
                let jsonData = try deconder.decode(T.self, from:  _data)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(CustomError(error.localizedDescription)))
            }
        })
        dataTask.resume()
    }

}



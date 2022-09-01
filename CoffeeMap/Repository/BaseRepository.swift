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

    private let apiKey: String = ""

    func get<T: Decodable>(url: URL, completion: @escaping ((Result<T>) -> Void)) {
        let headers = [
          "Accept": "application/json",
          "Authorization": apiKey
        ]
        
        let request = NSMutableURLRequest(url: url,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
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



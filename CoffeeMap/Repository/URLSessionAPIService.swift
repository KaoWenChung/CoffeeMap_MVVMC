//
//  BaseRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

struct URLSessionAPIService: APIService {

    func request<T: Decodable>(request: URLRequest, completion: ((Result<T>) -> Void)?) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            // Handle Error
            if let error = error {
                completion?(.failure(CustomError(error.localizedDescription)))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // Handle Empty Response
                completion?(.failure(CustomError("Empty Response")))
                print("Empty Response")
                return
            }
            guard let _data = data else {
                // Handle Empty Data
                completion?(.failure(CustomError("Empty Data")))
                print("Empty Data")
                return
            }
            do {
                // Parse the data
                let deconder = JSONDecoder()
                let jsonData = try deconder.decode(T.self, from:  _data)
                DispatchQueue.main.async {
                    completion?(.success(jsonData))
                }
            } catch let error {
                completion?(.failure(CustomError(error.localizedDescription)))
            }
        })
        dataTask.resume()
    }

}



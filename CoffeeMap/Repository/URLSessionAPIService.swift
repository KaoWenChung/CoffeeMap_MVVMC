//
//  BaseRepository.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import Foundation

enum URLError: Error {
    case statusCode
    case invalidImage
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> URLError {
        return (error as? URLError) ?? .other(error)
    }
}

struct URLSessionAPIService: APIService {

    func request<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError.statusCode
        }
        do {
            // Parse the data
            let deconder = JSONDecoder()
            let jsonData = try deconder.decode(T.self, from:  data)
            return jsonData
        } catch let error {
            throw error
        }
        /*
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            // Handle Error
            if let error = error {
//                completion?(.failure(error))
                throw error
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // Handle Empty Response
//                completion?(.failure(CustomError("Empty Response")))
                print("Empty Response")
                return
            }
            guard let _data = data else {
                // Handle Empty Data
//                completion?(.failure(CustomError("Empty Data")))
                print("Empty Data")
                return
            }
            do {
                // Parse the data
                let deconder = JSONDecoder()
                let jsonData = try deconder.decode(T.self, from:  _data)
                DispatchQueue.main.async {
//                    completion?(.success(jsonData))
                }
            } catch let error {
//                completion?(.failure(CustomError(error.localizedDescription)))
            }
        })
        dataTask.resume()
        */
    }

}



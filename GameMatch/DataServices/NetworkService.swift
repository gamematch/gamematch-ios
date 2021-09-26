//
//  NetworkService.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

final class NetworkService: DataService
{
    func get(request: DataRequest, completion: @escaping (Result<Data, Error>) -> Void)
    {
        URLSession.shared.dataTask(with: request.url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.invalidData))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    func post(request: DataRequest, parameters: [String: Any]?, completion: @escaping (Result<Data, Error>) -> Void)
    {
        let url = request.url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {
            if let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                urlRequest.httpBody = httpBody
            } else {
                completion(.failure(ServiceError.invalidData))
                return
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.invalidData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

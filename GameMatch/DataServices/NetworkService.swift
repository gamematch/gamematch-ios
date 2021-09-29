//
//  NetworkService.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation
import UIKit

final class NetworkService: DataService
{
    private let headers: [String: String?] = ["x-gm-api-key": "A42114554CC31DB186DE4581413C9",
                                              "x-gm-platform": "iOS\(UIDevice.current.systemVersion)",
                                              "x-gm-session-id": UserDefaults.standard.string(forKey: "sessionId")]
    
    func get(request: DataRequest, completion: @escaping (Result<Data, Error>) -> Void)
    {
        let url = request.url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
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
    
    func post(request: DataRequest, parameters: [String: Any]?, completion: @escaping (Result<Data, Error>) -> Void)
    {
        let url = request.url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
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

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
                                              "x-gm-session-id": SessionManager.shared.sessionId]
    
    func get(request: DataRequest,
             pathParams: String?,
             parameters: [String: String]?,
             completion: @escaping (Result<Data, Error>) -> Void)
    {
        let url: URL?
        if let pathParams = pathParams {
            url = request.getURL(pathParams: pathParams)
        } else {
            url = request.url
        }
        
        guard let url = url else {
            completion(.failure(ServiceError.invalidData))
            return
        }
        
        var components = URLComponents(url: url,
                                       resolvingAgainstBaseURL: false)
        components?.queryItems = parameters?.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        if let url = components?.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"

            sendUrlRequest(urlRequest,
                           completion: completion)
        } else {
            completion(.failure(ServiceError.invalidData))
        }
    }

    func delete(request: DataRequest,
                pathParams: String?,
                completion: @escaping (Result<Data, Error>) -> Void)
    {
        let url: URL?
        if let pathParams = pathParams {
            url = request.getURL(pathParams: pathParams)
        } else {
            url = request.url
        }

        guard let url = url else {
            completion(.failure(ServiceError.invalidData))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"

        sendUrlRequest(urlRequest,
                       completion: completion)
    }
    
    func put(request: DataRequest,
             pathParams: String? = nil,
             parameters: [String: Any?]?,
             completion: @escaping (Result<Data, Error>) -> Void)
    {
        let url: URL?
        if let pathParams = pathParams {
            url = request.getURL(pathParams: pathParams)
        } else {
            url = request.url
        }

        sendUrl(url,
                method: "PUT",
                parameters: parameters,
                completion: completion)
    }
    
    func post(request: DataRequest,
              parameters: [String: Any?]?,
              completion: @escaping (Result<Data, Error>) -> Void)
    {
        sendUrl(request.url,
                method: "POST",
                parameters: parameters,
                completion: completion)
    }

    func patch(request: DataRequest,
               pathParams: String?,
               parameters: [String: Any?]?,
               completion: @escaping (Result<Data, Error>) -> Void)
    {
        let url: URL?
        if let pathParams = pathParams {
            url = request.getURL(pathParams: pathParams)
        } else {
            url = request.url
        }

        sendUrl(url,
                method: "PATCH",
                parameters: parameters,
                completion: completion)
    }

    private func sendUrl(_ url: URL?,
                         method: String,
                         parameters: [String: Any?]?,
                         completion: @escaping (Result<Data, Error>) -> Void)
    {
        guard let url = url else {
            completion(.failure(ServiceError.invalidData))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        if let parameters = parameters {
            if let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                urlRequest.httpBody = httpBody
            } else {
                completion(.failure(ServiceError.invalidData))
                return
            }
        }

        sendUrlRequest(urlRequest,
                       completion: completion)
    }

    private func sendUrlRequest(_ urlRequest: URLRequest,
                                completion: @escaping (Result<Data, Error>) -> Void)
    {
        var urlRequest = urlRequest

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
}

//
//  BaseAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

class BaseAPIService
{
    internal func get<T: Decodable>(request: DataRequest,
                                    parameters: [String: String]?,
                                    completion: @escaping (Result<T, Error>) -> Void)
    {
        NetworkService().get(request: request,
                             parameters: parameters) { result in
            self.parseResult(result, completion: completion)
        }
    }
    
    internal func put(request: DataRequest,
                      pathParams: String?,
                      parameters: [String: Any?]?,
                      completion: @escaping (Result<Void, Error>) -> Void)
    {
        NetworkService().put(request: request,
                             pathParams: pathParams,
                             parameters: parameters) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    internal func post<T: Decodable>(request: DataRequest,
                                     parameters: [String: Any?]?,
                                     completion: @escaping (Result<T, Error>) -> Void)
    {
        NetworkService().post(request: request,
                              parameters: parameters) { result in
            self.parseResult(result, completion: completion)
        }
    }
    
    internal func post(request: DataRequest,
                       completion: @escaping (Result<Void, Error>) -> Void)
    {
        NetworkService().post(request: request,
                              parameters: nil) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func parseResult<T: Decodable>(_ result: Result<Data, Error>,
                                           completion: @escaping (Result<T, Error>) -> Void)
    {
        switch result {
        case .success(let data):
            do {
                let object: T = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                let gmError = GMError(message: String(decoding: data, as: UTF8.self))
                DispatchQueue.main.async {
                    completion(.failure(gmError))
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}

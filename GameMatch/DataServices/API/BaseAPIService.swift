//
//  BaseAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

class BaseAPIService
{
    internal func post<T: Decodable>(request: DataRequest,
                                     parameters: [String: Any?]?,
                                     completion: @escaping (Result<T, Error>) -> Void)
    {
        NetworkService().post(request: request,
                              parameters: parameters) { result in
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
}

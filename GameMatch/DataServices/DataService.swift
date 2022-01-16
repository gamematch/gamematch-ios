//
//  DataService.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

protocol DataService
{
    func get(request: DataRequest,
             pathParams: String?,
             parameters: [String: String]?,
             completion: @escaping (Result<Data, Error>) -> Void)
    
    func put(request: DataRequest,
             pathParams: String?,
             parameters: [String: Any?]?,
             completion: @escaping (Result<Data, Error>) -> Void)
    
    func post(request: DataRequest,
              parameters: [String: Any?]?,
              completion: @escaping (Result<Data, Error>) -> Void)

    func patch(request: DataRequest,
               pathParams: String?,
               parameters: [String: Any?]?,
               completion: @escaping (Result<Data, Error>) -> Void)
}

protocol DataRequest
{
    func getURL(pathParams: String?) -> URL?
}

extension DataRequest
{
    var url: URL?
    {
        return getURL(pathParams: nil)
    }
}

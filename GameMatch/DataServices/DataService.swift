//
//  DataService.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

protocol DataService
{
    func get(request: DataRequest, completion: @escaping (Result<Data, Error>) -> Void)
    func post(request: DataRequest, parameters: [String: Any?]?, completion: @escaping (Result<Data, Error>) -> Void)
}

protocol DataRequest
{
    var url: URL { get }
}

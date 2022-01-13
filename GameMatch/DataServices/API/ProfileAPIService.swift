//
//  ProfileAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 1/12/22.
//

import Foundation

class ProfileAPIService: BaseAPIService
{
    func get(completion: @escaping (Result<Profile, Error>) -> Void)
    {
        get(request: APIRequests.profile,
            parameters: nil,
            completion: { (result: Result<Profile, Error>) in
                            switch result {
                            case .success(let profile):
                                completion(.success(profile))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
    }
}

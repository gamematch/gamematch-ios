//
//  ProfileAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 1/12/22.
//

import UIKit

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

    func update(avatar: UIImage,
                completion: @escaping (Result<Void, Error>) -> Void)
    {
        let imageBase64String = avatar.pngData()?.base64EncodedString()

        patch(request: APIRequests.profile,
              pathParams: nil,
              parameters: ["image": imageBase64String],
              completion: completion)
    }
}

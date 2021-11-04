//
//  InviteAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 11/3/21.
//

import Foundation

class InviteAPIService: BaseAPIService
{
    func send(invitation: Invitation,
              completion: @escaping (Result<InviteState, Error>) -> Void)
    {
        post(request: APIRequests.invite,
             parameters: invitation.dict,
             completion: { (result: Result<InviteState, Error>) in
                            switch result {
                            case .success(let inviteState):
                                print("========== inviteState: \(inviteState) ===========")
                                completion(.success(inviteState))
                            case .failure(let error):
                                print("========== error: \(error) ===========")
                                completion(.failure(error))
                            }
                         })
    }
}

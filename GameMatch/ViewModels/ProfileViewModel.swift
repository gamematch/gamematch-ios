//
//  ProfileViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/3/21.
//

import Foundation

class ProfileViewModel
{
    func logout()
    {
        AuthenticationAPIService().logout(completion: { _ in })
    }
}

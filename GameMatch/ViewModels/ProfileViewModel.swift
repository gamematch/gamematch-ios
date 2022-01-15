//
//  ProfileViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/3/21.
//

import Foundation

class ProfileViewModel: BaseViewModel
{
    @Published var profile: Profile? = nil

    func getProfile()
    {
        loading = true
        ProfileAPIService().get { [weak self] result in
            self?.loading = false
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let error):
                self?.error = error
            }
        }
    }

    func logout()
    {
        AuthenticationAPIService().logout(completion: { _ in })
    }
}

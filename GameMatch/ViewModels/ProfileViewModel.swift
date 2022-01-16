//
//  ProfileViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 10/3/21.
//

import Foundation
import UIKit

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

    func uploadAvatar(_ avatar: UIImage)
    {
        let image = avatar.resize(to: CGSize(width: 100, height: 100))
        ProfileAPIService().update(avatar: image) { _ in }
    }

    func logout()
    {
        AuthenticationAPIService().logout(completion: { _ in })
    }
}

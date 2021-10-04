//
//  AuthenticationAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

class AuthenticationAPIService: BaseAPIService
{
    func signup(identity: String,
                completion: @escaping (Result<SignUpState, Error>) -> Void)
    {
        post(request: APIRequests.signup,
             parameters: ["identity": identity],
             completion: completion)
    }
    
    func register(identity: String,
                  code: String,
                  name: String,
                  password: String,
                  completion: @escaping (Result<LoginState, Error>) -> Void)
    {
        post(request: APIRequests.register,
             parameters: ["identity": identity,
                          "activation_code": code,
                          "name": name,
                          "password": password],
             completion: completion)
    }
    
    func login(identity: String,
               password: String,
               completion: @escaping (Result<LoginState, Error>) -> Void)
    {
        post(request: APIRequests.login,
             parameters: ["identity": identity,
                          "password": password],
             completion: completion)
    }
    
    func signup(socialNetwork: SocialNetwork,
                identity: String?,
                name: String?,
                userId: String,
                completion: @escaping (Result<LoginState, Error>) -> Void)
    {
        let request: APIRequests
        switch socialNetwork {
        case .facebook:
            request = .signupWithFacebook
        case .google:
            request = .signupWithGoogle
        case .apple:
            request = .signupWithApple
        }
        
        post(request: request,
             parameters: ["identity": identity,
                          "name": name,
                          "userId": userId],
             completion: completion)
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    {
        post(request: APIRequests.logout,
             completion: completion)
    }
}

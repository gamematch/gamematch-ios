//
//  SignInViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

class SignInViewModel
{
    var identity: String?
    
    func signup(identity: String,
                completion: @escaping (Result<SignUpState, Error>) -> Void)
    {
        AuthenticationAPIService().signup(identity: identity,
                                          completion: completion)
    }
    
    func register(identity: String,
                  code: String,
                  name: String,
                  password: String,
                  completion: @escaping (Result<LoginState, Error>) -> Void)
    {
        AuthenticationAPIService().register(identity: identity,
                                            code: code,
                                            name: name,
                                            password: password,
                                            completion: { result in
                                                switch result {
                                                case .success(let loginState):
                                                    UserDefaults.standard.set(loginState.sessionId, forKey: "sessionId")
                                                default:
                                                    break
                                                }
                                                completion(result)
                                            })
    }
    
    func login(identity: String,
               password: String,
               completion: @escaping (Result<LoginState, Error>) -> Void)
    {
        AuthenticationAPIService().login(identity: identity,
                                         password: password,
                                         completion: { result in
                                            switch result {
                                            case .success(let loginState):
                                                UserDefaults.standard.set(loginState.sessionId, forKey: "sessionId")
                                            default:
                                                break
                                            }
                                            completion(result)
                                        })
    }
}

//
//  APIRequests.swift
//  GameMatch
//
//  Created by Luke Shi on 9/25/21.
//

import Foundation

private let hostname = "https://api-dev.gamematch.net"

enum APIRequests: String, DataRequest
{
    case signup = "/api/v1/provision/signup"
    case register = "/api/v1/provision/register"
    
    case signupWithFacebook = "/api/v1/provision/facebook"
    case signupWithGoogle = "/api/v1/provision/google"
    case signupWithApple = "/api/v1/provision/apple"

    case login = "/api/v1/user/login"
    case logout = "/api/v1/user/logout"
    case forgotPassword = "/api/v1/user/forgot/password"
    
    case activities = "/api/v1/activities"

    var url: URL {
        return URL(string: hostname + rawValue)!
    }
}

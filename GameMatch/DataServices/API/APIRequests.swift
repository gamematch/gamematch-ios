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
    case login = "/api/v1/user/login"
    case signupWithFacebook = "/api/v1/provision/facebook"
    case signupWithGoogle = "/api/v1/provision/google"

    var url: URL {
        return URL(string: hostname + rawValue)!
    }
}

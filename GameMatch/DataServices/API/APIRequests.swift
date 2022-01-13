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
    
    case device = "/api/v1/device"
    
    case activities = "/api/v1/activities"
    case activity = "/api/v1/activity"
    case myActivities = "/api/v1/activities/self"

    case invite = "/api/v1/invite"

    case profile = "/api/v1/user/profile"
    
    func getURL(pathParams: String?) -> URL?
    {
        var urlString = hostname + rawValue
        if let pathParams = pathParams {
            urlString += "/\(pathParams)"
        }
        return URL(string: urlString)
    }
}

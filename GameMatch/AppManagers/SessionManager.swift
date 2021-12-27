//
//  SessionManager.swift
//  GameMatch
//
//  Created by Luke Shi on 9/29/21.
//

import Foundation

class SessionManager
{
    static let shared = SessionManager()
    
    private let sessionKey = "sessionId"

    var loggedIn: Bool
    {
        return sessionId != nil
    }
    
    var sessionId: String?
    {
        UserDefaults.standard.string(forKey: sessionKey)
    }

    func saveSession(_ sessionId: String)
    {
        UserDefaults.standard.set(sessionId, forKey: sessionKey)
    }
    
    func clear()
    {
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }
}

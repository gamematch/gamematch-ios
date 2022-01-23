//
//  User.swift
//  GameMatch
//
//  Created by Luke Shi on 1/12/22.
//

import Foundation

class User: NSObject, Codable
{
    let name: String?
    let identity: String?
    let url: String?
    let avatar: String?

    internal init(name: String?, contact: String?, url: String?)
    {
        self.name = name
        self.identity = contact
        self.url = url
        self.avatar = url
    }
}

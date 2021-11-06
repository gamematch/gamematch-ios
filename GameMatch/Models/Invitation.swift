//
//  Invitation.swift
//  GameMatch
//
//  Created by Luke Shi on 11/3/21.
//

import Foundation

class Invitation: NSObject, Codable
{
    let activityId: String
    let invites: [String]

    init(activityId: String, invites: [String])
    {
        self.activityId = activityId
        self.invites = invites

        super.init()
    }
}

class InviteState: NSObject, Codable
{
    let identity: String
    let status: String
}

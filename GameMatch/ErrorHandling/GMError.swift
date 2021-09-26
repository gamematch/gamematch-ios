//
//  GMError.swift
//  GameMatch
//
//  Created by Luke Shi on 9/26/21.
//

import Foundation

class GMError: Error
{
    var message: String
    
    init(message: String)
    {
        self.message = message
    }
}

enum ServiceError: Error
{
    case invalidData
}

//
//  Date+.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation

extension Date
{
    func display(format: String = "MM/dd h:mma") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

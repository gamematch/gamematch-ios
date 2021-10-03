//
//  Date+.swift
//  GameMatch
//
//  Created by Luke Shi on 10/2/21.
//

import Foundation

extension Date
{
    func display(format: String = "MM/dd hh:mm") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "PST")
        return dateFormatter.string(from: self)
    }
}

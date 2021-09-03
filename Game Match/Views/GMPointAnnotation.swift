//
//  GMPointAnnotation.swift
//  Game Match
//
//  Created by Luke Shi on 8/29/21.
//

import MapKit

class GMPointAnnotation: MKPointAnnotation
{
    var pinImageName: String
    
    init(named: String) {
        pinImageName = named
        super.init()
    }
}

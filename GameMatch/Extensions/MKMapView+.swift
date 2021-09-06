//
//  MKMapView+.swift
//  Game Match
//
//  Created by Luke Shi on 8/29/21.
//

import MapKit

extension MKMapView
{
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

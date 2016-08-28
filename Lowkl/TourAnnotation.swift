//
//  TourAnnotation.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 27/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import Foundation
import MapKit

let randomNames = ["Paseo Tec", "Cintermex", "Tec", "Fundidora"]

class TourAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var tourNumber: Int
    var tourName: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, tourNumber: Int) {
        self.coordinate = coordinate
        self.tourNumber = tourNumber
        self.tourName = randomNames[tourNumber - 1]
        self.title = self.tourName
    }
}
//
//  TourAnnotation.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 27/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import Foundation
import MapKit

var tours = ["Tec Tour, Cola de Caballo Tour, History Tour"]

class TourAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var tourNumber: Int
    var tourName: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, tourNumber: Int) {
        self.coordinate = coordinate
        self.tourNumber = tourNumber
        self.tourName = tours[tourNumber - 1]
        self.title = self.tourName
    }
}
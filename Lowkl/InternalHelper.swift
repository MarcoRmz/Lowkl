//
//  InternalHelper.swift
//  Lowkl
//
//  Created by Jorge Luis Perales on 28/08/16.
//  Copyright © 2016 Jorge Luis Perales. All rights reserved.
//

import Foundation

class InternalHelper {
    var tourName: String = ""
    var tourDescription: String = ""
    var coordinate = CLLocationCoordinate2D()
    
    static let sharedInstance: InternalHelper = InternalHelper()
}
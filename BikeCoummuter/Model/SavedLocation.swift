//
//  SavedLocation.swift
//  BikeCoummuter
//
//  Created by Erik Hede on 2018-04-09.
//  Copyright © 2018 Erik Hede. All rights reserved.
// Klass för som skapa en sparad plats

import Foundation
import UIKit
import CoreLocation

class SavedLocation {
    let name : String
    let lat :  Double
    let long : Double
    
    init(name: String, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLat() -> Double {
        return self.lat
    }
    
    func getLong() -> Double {
        return self.long
    }
    
}

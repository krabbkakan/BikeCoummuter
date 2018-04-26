//
//  DatabaseServices.swift
//  BikeCoummuter
//
//  Created by Erik Hede on 2018-04-24.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import Foundation
import Firebase

class DatabaseService {
    
    static let shared = DatabaseService()
    private init() {}
    
    let placesReference = Database.database().reference().child("posts")
    
    
}

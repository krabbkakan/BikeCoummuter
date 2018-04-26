//
//  Encouragements.swift
//  BikeCoummuter
//
//  Created by Erik Hede on 2018-04-09.
//  Copyright © 2018 Erik Hede. All rights reserved.

// Klass som skapar kommentarer till anv¨ndaren baserat på hur snabbt denne cyklar.

import Foundation
import UIKit

class Encouragements {
    
    
    let encouragementsDead : [String] = ["Did you break your hip?"]
    let encouragementsSlow : [String] = ["Bike Broken?"]
    let encouragementsMedium : [String] = ["Feels good to be outside, huh?"]
    let encouragementsFast : [String] = ["What did you have for breakfast this morning? Dunderhonung?"]
    let encouragementsRacingSpeed : [String] = ["Wow! I saw Lance armstrong way behind you!"]
    
    private init() {}
    
    func generateEncouragement(speed: Int) -> String {
        //tar in en int mellan 0-4, returnerar kommentar. Positiviteten i kommentaren i relation till intens värde.
        
        switch speed {
        case 0:
            return ""
        case 1:
            return ""
        case 2:
            return ""
        case 3:
            return ""
        case 4:
            return ""
        default:
            return ""
        }
    }
    
    
}

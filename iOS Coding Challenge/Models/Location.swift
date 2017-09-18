//
//  Location.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import SwiftyJSON
import RealmSwift

final class Location: Object, ResponseSerializable {
    
    dynamic var street: String = ""
    dynamic var city: String = ""
    dynamic var state: String = ""
    dynamic var postcode: Int = -1 // optional can not be stored in Realm
    
    var address: String {
        return state + ", " + city + ", " + street
    }
    
    convenience init?(json: JSON?) {
        self.init()
        
        guard let dict = json?.dictionary else {
            return nil
        }
        
        street          = dict["street"]?.string ?? ""
        city            = dict["city"]?.string ?? ""
        state           = dict["state"]?.string ?? ""
        postcode        = dict["postcode"]?.int ?? -1
    }
    
    convenience init?(copy loc: Location?) {
        self.init()
        
        guard let loc = loc else {
            return nil
        }
        
        street           = loc.street
        city             = loc.city
        state            = loc.state
        postcode         = loc.postcode
    }
}

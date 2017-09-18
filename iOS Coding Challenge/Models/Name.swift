//
//  Name.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import SwiftyJSON
import RealmSwift

final class Name: Object, ResponseSerializable {
    
    dynamic var title: String = ""
    dynamic var first: String = ""
    dynamic var last: String = ""
    
    convenience init?(json: JSON?) {
        self.init()
        
        guard let dict = json?.dictionary else {
            return nil
        }
        
        title           = dict["title"]?.string ?? ""
        first           = dict["first"]?.string ?? ""
        last            = dict["last"]?.string ?? ""
    }
    
    convenience init?(copy name: Name?) {
        self.init()
        
        guard let name = name else {
            return nil
        }
        
        title           = name.title
        first           = name.first
        last            = name.last
    }
}

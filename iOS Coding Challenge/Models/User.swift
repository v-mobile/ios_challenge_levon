//
//  User.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Users: ResponseSerializable {
    
    var items: [User] = []
    
    required init?(json: JSON?) {
        
        guard let array = json?.array else {
            return nil
        }
        
        for item in array {
            if let user = User(json: item) {
                items.append(user)
            }
        }
    }
    
    init() {}
}

extension Users {
    
    class func loadRandom(completion: @escaping ((Users?, ResponseError?) -> Void)) {
        
        let url = "https://randomuser.me/api/?results=100"

        NetworkManager.shared.invokeRequestWithObject(method: .get, url: url, queryParams: nil, additionalHeaders: nil) { (users: Users?, error: ResponseError?) in
            
            completion(users, error)
        }
    }
}

final class User: Object, ResponseSerializable {
    
    override class func primaryKey() -> String? {
        return "email"
    }
    
    dynamic var gender: String = ""
    dynamic var name: Name?
    dynamic var location: Location?
    dynamic var email: String = ""
    dynamic var dob: String?
    dynamic var registered: String?
    dynamic var phone: String = ""
    dynamic var cell: String = ""
    dynamic var picture: Picture?
    
    var fullName: String {
        var str: String = ""
        if let title = name?.title {
            str += title + " "
        }
        if let first = name?.first {
            str += first + " "
        }
        if let last = name?.last {
            str += last
        }
        return str
    }
    
    convenience init?(json: JSON?) {
        self.init()
        
        guard let dict = json?.dictionary else {
            return nil
        }
        
        gender          = dict["gender"]?.string ?? ""
        name            = Name(json: dict["name"])
        location        = Location(json: dict["location"])
        email           = dict["email"]?.string ?? ""
        phone           = dict["phone"]?.string ?? ""
        cell            = dict["cell"]?.string ?? ""
        picture         = Picture(json: dict["picture"])
        dob             = dict["dob"]?.string
        registered      = dict["registered"]?.string
    }
    
    convenience init?(copy user: User?) {
        self.init()
        
        guard let user = user else {
            return nil
        }
        
        gender          = user.gender
        name            = Name(copy: user.name)
        location        = Location(copy: user.location)
        email           = user.email
        dob             = user.dob
        registered      = user.registered
        phone           = user.phone
        cell            = user.cell
        picture         = Picture(copy: user.picture)
    }
}

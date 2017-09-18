//
//  Picture.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import SwiftyJSON
import RealmSwift

final class Picture: Object, ResponseSerializable {
    
    dynamic var large: String = ""
    dynamic var medium: String = ""
    dynamic var thumbnail: String = ""
    
    convenience init?(json: JSON?) {
        self.init()
        
        guard let dict = json?.dictionary else {
            return nil
        }
        
        large           = dict["large"]?.string ?? ""
        medium          = dict["medium"]?.string ?? ""
        thumbnail       = dict["thumbnail"]?.string ?? ""
    }
    
    convenience init?(copy pic: Picture?) {
        self.init()
        
        guard let pic = pic else {
            return nil
        }
        
        large           = pic.large
        medium          = pic.medium
        thumbnail       = pic.thumbnail
    }
}

//
//  RequestMethods.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import Alamofire

enum RequestMethod {
    case get
    case put
    case post
    case delete
    case patch
    
    var type: HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .put:
            return HTTPMethod.put
        case .post:
            return HTTPMethod.post
        case .delete:
            return HTTPMethod.delete
        case .patch:
            return HTTPMethod.patch
        }
    }
}

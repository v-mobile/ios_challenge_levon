//
//  ResponseError.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import Foundation

public enum ResponseError: Error {
    
    case network(error: NSError)
    case backend(message: String, displayMessage: String)
    case custom(reason: String)
    
    var message: String {
        switch self {
        case .network(let error):
            return error.domain
        case .backend(let message, _):
            return message
        case .custom(let reason):
            return reason
        }
    }
}

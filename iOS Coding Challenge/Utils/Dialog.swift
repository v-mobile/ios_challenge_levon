//
//  Dialoh.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import UIKit

class Dialog {
    
    class func show(title: String, message: String, target: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        target.present(alert, animated: true, completion: nil)
    }
}

//
//  UITableView.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerNib(named: String, forCellReuseIdentifier reuseIdentifier: String) {
        let nib = UINib(nibName: named, bundle: nil)
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}


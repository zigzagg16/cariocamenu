//
//  CariocaMenu+Utils.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

extension CariocaMenu {
    ///Generates an Equal constraint
    ///- Parameter item: The reference
    ///- Parameter toItem: The linked view
    ///- Parameter attribute: The NSLayoutAttribute
    ///- Parameter constant: The constant value. Default: 0
    ///- Returns: NSLayoutConstraint: The prepared constraint
    class func equalConstraint(_ item: AnyObject,
                               toItem: AnyObject,
                               attribute: NSLayoutAttribute,
                               constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item,
                                  attribute: attribute,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: attribute,
                                  multiplier: 1,
                                  constant: constant)
    }
    ///Logs a string in the console
    ///- Parameter log: The log message
    class func log(_ log: String) { print("[🇧🇷 CariocaMenu] \(log)") }
}

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
    /**
     Generates an Equal constraint
     - returns: `NSlayoutConstraint` an equal constraint for the specified parameters
     */
    class func equalConstraint(_ item: AnyObject,
                               toItem: AnyObject,
                               attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item,
                                  attribute: attribute,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: attribute,
                                  multiplier: 1,
                                  constant: 0)
    }
    ///Logs a string in the console
    ///- parameters:
    ///  - log: String to log
    class func log(_ log: String) { print("🇧🇷 CariocaMenu :: \(log)") }
}

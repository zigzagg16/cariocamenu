//
// CariocaMenu+Utils.swift
//

import UIKit

extension CariocaMenu {
// MARK: - Constraints
    /**
     Generates an Equal constraint
     - returns: `NSlayoutConstraint` an equal constraint for the specified parameters
     */
    class func getEqualConstraint(_ item: AnyObject,
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
    /**
     Gets the saved value for the vertical boomerang
     - returns: `CGFloat` The boomerang vertical value
     */
    class func getBoomerangVerticalValue() -> CGFloat {
        let offset = UserDefaults.standard.double(forKey: userDefaultsBoomerangVerticalKey)
        return(CGFloat(offset))
    }
    /**
     Gets the saved value for the horizontal boomerang
     - returns: `CariocaMenuEdge` the boomerang matching edge
     */
    class func getBoomerangHorizontalValue() -> CariocaMenuEdge {
        let int = UserDefaults.standard.integer(forKey: userDefaultsBoomerangHorizontalKey)
        return int == 1 ? .right : .left
    }

    ///Resets the boomerang saved values
    class func resetBoomerangValues() {
        UserDefaults.standard.setValue(nil, forKey: userDefaultsBoomerangVerticalKey)
        UserDefaults.standard.setValue(nil, forKey: userDefaultsBoomerangHorizontalKey)
        UserDefaults.standard.synchronize()
    }

    // MARK: - Logs
    ///Logs a string in the console
    ///- parameters:
    ///  - log: String to log
    class func log(_ log: String) { print("CariocaMenu :: \(log)") }
}

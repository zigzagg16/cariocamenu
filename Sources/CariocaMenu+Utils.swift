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

extension UIView {
	///Generates 4 NSLayoutConstraints
	///- Parameter superview: The superview to which the view will stick
	///- Returns: [NSLayoutConstraint]: The 4 constraints in CSS Style order (Top, Right, Bottom, Left)
	func makeAnchorConstraints(to superview: UIView) -> [NSLayoutConstraint] {
		return [self.topAnchor.constraint(equalTo: superview.topAnchor),
				self.rightAnchor.constraint(equalTo: superview.rightAnchor),
				self.leftAnchor.constraint(equalTo: superview.leftAnchor),
				self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)]
	}
}

///Selector shortcuts, used for gestures
extension Selector {
	///Gesture for panning from any screen edge
	static let pannedFromScreenEdge = #selector(CariocaGestureManager.panGestureEvent(_:))
	///Gesture when the user taps the indicator view to display the menu
	static let tappedIndicatorView = #selector(CariocaMenu.tappedIndicatorView(_:))
}

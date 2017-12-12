//
// CariocaMenu.swift
//

import Foundation
import UIKit

extension CariocaMenu {
    // MARK: - Gesture helper views
    /**
     Adds Gesture helper views in the container view.
     Recommended when the whole view scrolls (`UIWebView`,`MKMapView`,...)
     - parameters:
     - edges: An array of `CariocaMenuEdge` on which to show the helpers
     - width: The width of the helper view. Maximum value should be `40`, but you're free to put what you want.
     */
    open func addGestureHelperViews(_ edges: [CariocaMenuEdge], width: CGFloat) {

        if edges.contains(.left) {
            gestureHelperViewLeft?.removeFromSuperview()
            gestureHelperViewLeft = prepareGestureHelperView(.leading, width: width)
        }
        if edges.contains(.right) {
            gestureHelperViewRight?.removeFromSuperview()
            gestureHelperViewRight = prepareGestureHelperView(.trailing, width: width)
        }
        hostView.bringSubview(toFront: leftIndicatorView)
        hostView.bringSubview(toFront: rightIndicatorView)
    }

    /**
     Generates a gesture helper view with autolayout constraints
     - parameters:
     - edgeAttribute: `.Leading` or `.Trailing`
     - width: The width of the helper view.
     - returns: `UIView` The helper view constrained to the hostView edge
     */
    private func prepareGestureHelperView(_ edgeAttribute: NSLayoutAttribute, width: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        hostView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        hostView.addConstraints([
            CariocaMenu.getEqualConstraint(view, toItem: hostView, attribute: edgeAttribute),
            NSLayoutConstraint(item: view,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: width),
            CariocaMenu.getEqualConstraint(view, toItem: hostView, attribute: .bottom),
            CariocaMenu.getEqualConstraint(view, toItem: hostView, attribute: .top)
            ])

        view.setNeedsLayout()
        return view
    }
}

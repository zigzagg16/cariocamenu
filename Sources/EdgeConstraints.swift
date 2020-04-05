import UIKit

/// Structure to hold four edge constraints between view and its superview
public struct EdgeConstraints {
    /// The top edge constraint.
    let top: NSLayoutConstraint

    /// The left edge constraint.
    let left: NSLayoutConstraint

    /// The bottom edge constraint.
    let bottom: NSLayoutConstraint

    /// The right edge constraint.
    let right: NSLayoutConstraint

    /// Returns an array representation
    /// - Returns: all four constraint in array representation
    func toArray() -> [NSLayoutConstraint] {
        return [top, left, bottom, right]
    }

    /// Modifies `constant` of held constraints with specified insets
    /// - Parameter edgeInsets: Desired insets between view and it's superview to be applied.
    func apply(edgeInsets insets: UIEdgeInsets) {
        top.constant = insets.top
        left.constant = insets.left
        bottom.constant = insets.bottom
        right.constant = insets.right
    }
}

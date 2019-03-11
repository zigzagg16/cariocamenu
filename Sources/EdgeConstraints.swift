//
// Created by Alex Katsz on 2019-03-11.
// Copyright (c) 2019 CariocaMenu. All rights reserved.
//

import UIKit

public struct EdgeConstraints {
    let top: NSLayoutConstraint

    let left: NSLayoutConstraint

    let bottom: NSLayoutConstraint

    let right: NSLayoutConstraint

    func toArray() -> [NSLayoutConstraint] {
        return [top, left, bottom, right]
    }

    func apply(edgeInsets insets: UIEdgeInsets) {
        top.constant = insets.top
        left.constant = insets.left
        bottom.constant = insets.bottom
        right.constant = insets.right
    }
}

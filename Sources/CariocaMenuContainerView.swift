//
//  CariocaMenuContainerView.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

public class CariocaMenuContainerView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, temp: Bool) {
        self.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

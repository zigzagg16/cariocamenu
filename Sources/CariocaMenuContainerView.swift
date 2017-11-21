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

    let topConstraint: NSLayoutConstraint

    init(frame: CGRect, dataSource: CariocaController) {
        topConstraint = NSLayoutConstraint()
        super.init(frame: frame)
        addSubview(dataSource.view)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

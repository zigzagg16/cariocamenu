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

    var topConstraint: NSLayoutConstraint
    var menuHeight: CGFloat

    init(frame: CGRect, dataSource: CariocaController) {
        topConstraint = NSLayoutConstraint()
        // TODO: Calculate proper height
        menuHeight = 180.0
        super.init(frame: frame)
        addSubview(dataSource.view)
        dataSource.tableView.isScrollEnabled = false
        //Autolayout constraints for the menu
        dataSource.view.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = CariocaMenu.equalConstraint(dataSource.view, toItem: self, attribute: .top)
        topConstraint.constant = 140.0
        self.addConstraints([
            topConstraint,
            NSLayoutConstraint(item: dataSource.view,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: menuHeight),
            CariocaMenu.equalConstraint(dataSource.view, toItem: self, attribute: .width),
            CariocaMenu.equalConstraint(dataSource.view, toItem: self, attribute: .leading)
        ])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

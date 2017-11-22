//
//  CariocaMenuContainerView.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

///The menu's container view
public class CariocaMenuContainerView: UIView {
    ///The top constraint. Used to move the menu's Y position
    var topConstraint: NSLayoutConstraint
    ///The menu's height
    let menuHeight: CGFloat

    ///Initialises the containerview
    ///- Parameter frame: The hostView frame
    ///- Parameter dataSource: The menu's dataSource
    init(frame: CGRect, dataSource: CariocaController) {
        topConstraint = NSLayoutConstraint()
        menuHeight = dataSource.heightForRow() * CGFloat(dataSource.numberOfRows(dataSource.tableView))
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
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

    ///:nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

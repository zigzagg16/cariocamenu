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
        menuHeight = dataSource.heightForRow() * CGFloat(dataSource.menuItems.count)
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dataSource.view)
        dataSource.tableView.isScrollEnabled = false
        //Autolayout constraints for the menu
        dataSource.view.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = CariocaMenu.equalConstraint(dataSource.view, toItem: self, attribute: .top)
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

	///Adds the blur view as a subview
	///- Parameter style: The blur effect style
	func addBlurView(style: UIBlurEffectStyle) {
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
			as UIVisualEffectView
		visualEffectView.frame = self.frame
		visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		addSubview(visualEffectView)
		sendSubview(toBack: visualEffectView)
	}

    ///:nodoc:
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

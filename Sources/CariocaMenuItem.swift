//
//  CariocaMenuItem.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 01/12/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

///Carioca Menu Item
public class CariocaMenuItem {
	///The item's title
	let title: String
	///The item'sicon
	let indicatorIcon: CariocaMenuItemIndicatorIcon
	
	///Initialise a menu item
	///- Parameter title: The item's title
	///- Parameter indicatorIcon: The icon displayed in the menu indicator
	init(_ title: String, _ indicatorIcon: CariocaMenuItemIndicatorIcon) {
		self.title = title
		self.indicatorIcon = indicatorIcon
	}
}

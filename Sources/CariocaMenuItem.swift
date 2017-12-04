//
//  CariocaMenuItem.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 01/12/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

public enum CariocaMenuItemIndicatorIcon {
	case emoji(String)
	case icon(UIImage)
}

///Carioca Menu Item
public class CariocaMenuItem {
	let title: String
	let indicatorIcon: CariocaMenuItemIndicatorIcon

	init(_ title: String, _ indicatorIcon: CariocaMenuItemIndicatorIcon) {
		self.title = title
		self.indicatorIcon = indicatorIcon
	}
}

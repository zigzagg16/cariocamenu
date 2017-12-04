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
	let title: String
	let emoji: String?
	let icon: UIImage?

	init(_ title: String, _ emoji: String? = nil, _ icon: UIImage? = nil) {
		self.title = title
		self.emoji = emoji
		self.icon = icon
	}
}

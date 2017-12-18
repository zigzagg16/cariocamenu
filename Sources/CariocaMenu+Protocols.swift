//
//  CariocaMenu+Protocols.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

public typealias CariocaController = UITableViewController & CariocaDataSource

///DataSource protocol for filling up the menu
public protocol CariocaDataSource {
	///The menu items
	var menuItems: [CariocaMenuItem] { get set }
    ///Specifies the height of each row.
    ///ℹ️ All rows will have the same height
    func heightForRow() -> CGFloat
	///The cell for a specific edge
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath,
				   withEdge edge: UIRectEdge) -> UITableViewCell
	///The blur style, optional
	var blurStyle: UIBlurEffectStyle? { get }
	///Can the menu go offscreen with user's gesture ? (true)
	///Or should it always stay fully visible ? (false)
	var isOffscreenAllowed: Bool { get set }
	///The indicator's initial position, in %. Top : 0%, Center: 50%, Bottom: 100%.
	var indicatorPosition: CGFloat { get }
	///The indicator's Boomerang type.
	var boomerang: BoomerangType { get set }
}

///The menu's events delegate
public protocol CariocaDelegate: class {
    ///The user selected a menu item. The menu will close and hide.
    ///- Parameter menu: The menu instance
	///- Parameter item: The selected menu item
    ///- Parameter index: The index of the selected item
	func cariocamenu(_ menu: CariocaMenu, didSelect item: CariocaMenuItem, at index: Int)
    ///Menu will open
    ///- Parameter menu: The menu instance
    ///- Parameter edge: The opening edge of the menu
    func cariocamenu(_ menu: CariocaMenu, willOpenFromEdge edge: UIRectEdge)
}

///Forwards the events between CariocaMenu and CariocaGestureManager
protocol CariocaGestureManagerDelegate: class {
    ///The selected index
    var selectedIndex: Int { get }
    ///Menu will open
    ///- Parameter edge: The opening edge of the menu
    func willOpenFromEdge(edge: UIRectEdge)
	///The selection index was updated
	///- Parameter index: The updated selection index
	///- Parameter selectionFeedback: Should we make a selection feedback
	func didUpdateSelectionIndex(_ index: Int, selectionFeedback: Bool)
    ///The user did select an item at index
    func didSelectItem(at index: Int)
}

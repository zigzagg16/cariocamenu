//
//  CariocaMenu+Protocols.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

typealias CariocaController = UITableViewController & CariocaDataSource

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
}
///The menu's events delegate
public protocol CariocaDelegate: class {
    ///The user selected a menu item
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
    ///Shows the menu
    func showMenu()
    ///hides the menu
    func hideMenu()
    ///Updated the Y position of the menu
    func didUpdateY(_ yValue: CGFloat)
    ///Changed of selection index
    func didUpdateSelectionIndex(_ index: Int)
    ///The user did select an item at index
    func didSelectItem(at index: Int)
}

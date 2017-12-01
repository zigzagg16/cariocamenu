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
public protocol CariocaDataSource: UITableViewDataSource {
    ///Specifies the height of each row.
    ///ℹ️ All rows will have the same height
    func heightForRow() -> CGFloat
    ///The total number of rows in the menu
    func numberOfRows(_ tableView: UITableView) -> Int
}
extension CariocaDataSource {
    ///Default, only one section is allowed for now
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    ///Returns the number of rows
    func numberOfRows(_ tableViewItem: UITableView) -> Int {
        return tableView(tableViewItem, numberOfRowsInSection: 0)
    }
}
///The menu's events delegate
public protocol CariocaDelegate: class {
    ///The user selected a menu item
    ///- Parameter menu: The menu instance
    ///- Parameter index: The index of the selected item
    func cariocamenu(_ menu: CariocaMenu, didSelectItemAt index: Int)
    ///Menu will open
    ///- Parameter menu: The menu instance
    ///- Parameter edge: The opening edge of the menu
    func cariocamenu(_ menu: CariocaMenu, willOpenFromEdge edge: UIRectEdge)
}

///Delegate for UITableView events
class CariocaTableViewDelegate: NSObject, UITableViewDelegate {
    ////The carioca events delegate
    weak var delegate: CariocaDelegate?
    ///The rowHeight of each menu item
    let rowHeight: CGFloat
    ///The carioca menu
    weak var menu: CariocaMenu?

    ///Initialisation of the UITableView delegate
    ///- Parameter delegate: The menu event's delegate (to forward selection events)
    ///- Parameter rowHeight: The menu's row height.
    init(delegate: CariocaDelegate,
         rowHeight: CGFloat) {
        self.delegate = delegate
        self.rowHeight = rowHeight
    }

    ///UITableView selection delegate, forwarded to CariocaDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = menu else { return }
        delegate?.cariocamenu(menu, didSelectItemAt: indexPath.row)
    }

    ///Takes the specified rowHeight passed in the initialiser
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

extension CariocaTableViewDelegate {
    ///Default footer view (to hide extra separators)
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
    }
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
    ///The user did select an item at index
    func didSelectItem(at index: Int)
}

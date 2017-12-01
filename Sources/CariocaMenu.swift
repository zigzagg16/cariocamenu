//
//  CariocaMenu.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit
///🇧🇷 Carioca Menu 🇧🇷
public class CariocaMenu: CariocaGestureManagerDelegate {
    ///The menu's content controller
    let dataSource: CariocaController
    ///The view in which the menu will be displayed
    let hostView: UIView
    ///The edges of the menu. Supported : .left, .right
    let edges: [UIRectEdge]
    ///The container view. Created programatically,
    ///it takes the same dimensions as the host view
    let container: CariocaMenuContainerView
    ///Boomerang type. Default : .none
    var boomerang: BoomerangType = .none
    ///Gestures manager
    let gestureManager: CariocaGestureManager
    ///Can the menu go offscreen with user's gesture ? (true)
    ///Or should it always stay fully visible ? (false)
    var isOffscreenAllowed = true
    // swiftlint:disable weak_delegate
    ///Receiver of UITableView events
    let tableViewDelegate: CariocaTableViewDelegate
    // swiftlint:enable weak_delegate
    ///The selected index of the menu. Default: 0
    var selectedIndex: Int = 1
    ///The delegate receiving menu's events
    weak var delegate: CariocaDelegate?

    ///Initialises 🇧🇷 Carioca Menu 🇧🇷
    ///- Parameter dataSource: The menu's dataSource
    ///- Parameter hostView: The view in which the menu will be displayed
    ///- Parameter edges: The supported edges
    ///- Parameter delegate: The menu's event delegate
    init(dataSource: CariocaController,
         hostView: UIView,
         edges: [UIRectEdge],
         delegate: CariocaDelegate) {
        self.dataSource = dataSource
        self.hostView = hostView
        self.edges = edges
        self.container = CariocaMenuContainerView(frame: hostView.frame,
                                                  dataSource: dataSource)
        self.tableViewDelegate = CariocaTableViewDelegate(delegate: delegate,
                                                          rowHeight: dataSource.heightForRow())
        self.gestureManager = CariocaGestureManager(hostView: hostView,
                                                    controller: dataSource,
                                                    edges: edges,
                                                    container: self.container)
        self.delegate = delegate
        self.gestureManager.delegate = self
        self.tableViewDelegate.menu = self
        self.dataSource.tableView.delegate = tableViewDelegate
        self.hideMenu()
    }

    ///Adds the menu's container view in the host view
    func addInHostView() {
        hostView.addSubview(container)
        hostView.addConstraints([
            CariocaMenu.equalConstraint(container, toItem: hostView, attribute: .left),
            CariocaMenu.equalConstraint(container, toItem: hostView, attribute: .top),
            CariocaMenu.equalConstraint(container, toItem: hostView, attribute: .right),
            CariocaMenu.equalConstraint(container, toItem: hostView, attribute: .bottom)
        ])
    }

    // MARK: Events delegate/forwarding

    ///Menu will open
    ///- Parameter edge: The opening edge of the menu
    func willOpenFromEdge(edge: UIRectEdge) {
        delegate?.cariocamenu(self, willOpenFromEdge: edge)
    }
    func showMenu() {
        container.isHidden = false
    }
    func hideMenu() {
        container.isHidden = true
    }
    func didUpdateY(_ yValue: CGFloat) {
        //should we do something ?
    }
    func didSelectItem(at index: Int) {
        print("did select \(index)")
        selectedIndex = index
        /*menuOriginalY = location.y
         //Unselect the previously selected cell, but first, update the selectedIndexPath
         let indexPathForDeselection = selectedIndexPath
         selectedIndexPath = preSelectedIndexPath
         dataSource.unselectRowAtIndexPath(indexPathForDeselection)
         didSelectRowAtIndexPath(selectedIndexPath, fromContentController: true)*/
        /*
         if preSelectedIndexPath !=  calculatedIndexPath {
         if preSelectedIndexPath != nil {
         dataSource.unselectRowAtIndexPath(preSelectedIndexPath)
         }
         preSelectedIndexPath = calculatedIndexPath
         dataSource.preselectRowAtIndexPath(preSelectedIndexPath)
         }
         updateIndicatorsForIndexPath(preSelectedIndexPath)
         }*/
    }
}

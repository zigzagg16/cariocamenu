//
//  CariocaMenu.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

public class CariocaMenu {
    /// The menu's content controller
    let dataSource: CariocaController
    /// The view in which the menu will be displayed
    let hostView: UIView
    /// The edges of the menu. Supported : .left, .right
    let edges: [UIRectEdge]
    /// The container view. Created programatically,
    /// it takes the same dimensions as the host view
    let container: CariocaMenuContainerView
    /// Boomerang type. Default : .none
    var boomerang: BoomerangType = .none
    /// Gestures manager
    let gestureManager: CariocaGestureManager
    /// Can the menu go offscreen with user's gesture ? (true)
    /// Or should it always stay fully visible ? (false)
    var isOffscreenAllowed = true
    ///Receiver of UITableView events
    // swiftlint:disable weak_delegate
    let tableViewDelegate: CariocaTableViewDelegate
    // swiftlint:enable weak_delegate

    init(dataSource: CariocaController,
         hostView: UIView,
         edges: [UIRectEdge],
         delegate: CariocaDelegate) {
        self.dataSource = dataSource
        self.hostView = hostView
        self.edges = edges
        self.container = CariocaMenuContainerView(frame: hostView.frame,
                                                  dataSource: dataSource)
        self.gestureManager = CariocaGestureManager(hostView: hostView,
                                                    controller: dataSource,
                                                    edges: edges)
        //Set delegate
        tableViewDelegate = CariocaTableViewDelegate(delegate: delegate,
                                                     rowHeight: dataSource.heightForRow())
        dataSource.tableView.delegate = tableViewDelegate
        self.show()
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
    ///Hide the menu
    private func hide() {
        container.isHidden = true
    }
    ///Show the menu
    private func show() {
        container.isHidden = false
    }
}

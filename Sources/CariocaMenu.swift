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

    let dataSource: CariocaController
    let hostView: UIView
    let edges: [UIRectEdge]
    let container: CariocaMenuContainerView
    ///Boomerang type. Default : .none
    var boomerang: BoomerangType = .none
    ///Gestures manager
    let gestureManager: CariocaGestureManager

    init(dataSource: CariocaController,
         hostView: UIView,
         edges: [UIRectEdge]) {
        self.dataSource = dataSource
        self.hostView = hostView
        self.edges = edges
        self.container = CariocaMenuContainerView(frame: hostView.frame,
                                                  dataSource: dataSource)
        self.gestureManager = CariocaGestureManager(hostView: hostView,
                                                    controller: dataSource,
                                                    edges: edges)
    }

    ///Adds the menu's container view in the host view
    func addInHostView() {
        hostView.addSubview(container)
    }
}

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
    let edges: [CariocaEdge]
    let container: CariocaMenuContainerView
    ///Boomerang type. Default : .none
    var boomerang: BoomerangType = .none

    init(dataSource: CariocaController,
         hostView: UIView,
         edges: [CariocaEdge]) {
        self.dataSource = dataSource
        self.hostView = hostView
        self.edges = edges
        self.container = CariocaMenuContainerView(frame: hostView.frame,
                                                  dataSource: dataSource)
    }

    ///Adds the menu's container view in the host view
    func addInHostView() {
        hostView.addSubview(container)
    }
}

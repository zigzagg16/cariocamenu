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

    init(dataSource: CariocaController,
         hostView: UIView) {
        self.dataSource = dataSource
        self.hostView = hostView
    }
    func addInHostView() {
        hostView.addSubview(dataSource.view)
    }
}

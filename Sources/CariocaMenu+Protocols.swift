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

}

extension CariocaDataSource {
    ///Default, only one section is allowed for now
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

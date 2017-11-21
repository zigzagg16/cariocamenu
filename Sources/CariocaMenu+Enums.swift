//
//  CariocaMenu+Enums.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation

///The possible edges of the menu
@objc public enum CariocaEdge: Int {
    ///Left of the screen
    case left = 0
    ///Right of the screen
    case right = 1
}

///The boomerang types.
@objc public enum BoomerangType: Int {
    ///The indicators will always return where they were let.
    case none = 0
    ///The indicators will always come back at the same Y value. They may switch from Edge if the user wants.
    case vertical = 1
    ///The indicators will always come back at the exact same place
    case verticalAndHorizontal = 2
}

//
//  CariocaMenu+Enums.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation

///The boomerang types.
public enum BoomerangType: Int {
    ///The indicators will always return where they were let.
    case none = 0
	///The indicator will return always on the original edge.
	case horizontal = 1
    ///The indicators will always come back at the same Y value. It may switch from Edge if the user wants.
    case vertical = 2
    ///The indicators will always come back at the exact same place
    case verticalHorizontal = 3
}

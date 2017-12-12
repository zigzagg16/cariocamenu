//
//CariocaMenuEnums.swift
//
import Foundation

///The opening edge of the menu.
///- `left`: Left edge of the screen
///- `right`: Right edge of the screen
@objc public enum CariocaMenuEdge: Int {
    ///Left of the screen
    case left = 0
    ///Right of the screen
    case right = 1
}

///The initial vertical position of the menu
///- `Top`: Top of the hostView
///- `Center`: Center of the hostView
///- `Bottom`: Bottom of the hostView
@objc public enum CariocaMenuIndicatorViewPosition: Int {
    ///Top of the hostView
    case top = 0
    ///Center of the hostView
    case center = 1
    ///Bottom of the hostView
    case bottom = 2
}

///The boomerang type of the menu.
///- `None`: Default value. The indicators will always return where they were let.
///- `Vertical`: The indicators will always come back at the same Y value. They may switch from Edge if the user wants.
///- `VerticalAndHorizontal`: The indicators will always come back at the exact same place
@objc public enum CariocaMenuBoomerangType: Int {
    ///Default value. The indicators will always return where they were let.
    case none = 0
    ///The indicators will always come back at the same Y value. They may switch from Edge if the user wants.
    case vertical = 1
    ///The indicators will always come back at the exact same place
    case verticalAndHorizontal = 2
}

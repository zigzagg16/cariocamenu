//
//  CariocaGestureManager.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension Selector {
    static let pannedFromScreenEdge = #selector(CariocaGestureManager.panGestureEvent(_:))
}

///Manages all the gestures
class CariocaGestureManager {
    ///The hostview of the menu
    let hostView: UIView
    ///The menu's controller
    let controller: CariocaController
    ///The edges of the menu
    let edges: [UIRectEdge]
    ///The menu's opening edge
    let openingEdge: UIRectEdge
    ///The edge gestures
    let edgePanGestures: [UIScreenEdgePanGestureRecognizer] = []
    ///The pre-calculated menu's height
    let menuHeight: CGFloat
    ///The events delegate
    weak var delegate: CariocaGestureManagerDelegate?
    ///The Y position in which the ScreenEdgePan started.
    var originalScreeenEdgePanY: CGFloat = 0.0

    ///Initialises the gesture manager
    ///- Parameter hostView: The menu's host view
    ///- Parameter controller: The menu's content controller
    ///- Parameter edges: The menu's edges
    ///- Parameter menuHeight: The pre-calculated menu's height
    init(hostView: UIView,
         controller: CariocaController,
         edges: [UIRectEdge],
         menuHeight: CGFloat) {
        //TODO: Check that the edges are only .left or .right, as they are the only supported
        self.hostView = hostView
        self.controller = controller
        self.edges = edges
        self.openingEdge = edges.first!
        self.menuHeight = menuHeight
        makeEdgePanGestures()
    }

    ///Create the required gestures depending on the edges
    func makeEdgePanGestures() {
        edges.forEach { edge in
            let panGesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                              action: .pannedFromScreenEdge)
            panGesture.edges = edge
            hostView.addGestureRecognizer(panGesture)
        }
    }
    ///Pan gesture event received
    ///- Parameter gesture: UIPanGestureRecognizer
    @objc func panGestureEvent(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let yLocation = gesture.location(in: gesture.view).y
//        let edge = gesture.edges
        let frameHeight = hostView.frame.height
        let minimumY: CGFloat = 20.0 // statusBar
        let maximumY: CGFloat = frameHeight - menuHeight
        // TODO: Find the matching indicator view based on the edge
        if gesture.state == .began {
            delegate?.willOpenFromEdge(edge: gesture.edges)
            originalScreeenEdgePanY = yLocation
            print("height \(frameHeight)")
            print("min : \(minimumY) max: \(maximumY)")
        }
    }
}

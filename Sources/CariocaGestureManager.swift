//
//  CariocaGestureManager.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

///Manages all the gestures
class CariocaGestureManager {
    ///The hostview of the menu
    let hostView: UIView
    ///The menu's controller
    let controller: CariocaController
    ///The edges of the menu
    let edges: [UIRectEdge]
    ///The edge gestures
    let edgePanGestures: [UIScreenEdgePanGestureRecognizer] = []

    ///Initialises the gesture manager
    /// - Parameter hostView: The menu's host view
    /// - Parameter controller: The menu's content controller
    /// - Parameter edges: The menu's edges
    init(hostView: UIView, controller: CariocaController, edges: [UIRectEdge]) {
        self.hostView = hostView
        self.controller = controller
        self.edges = edges
        makeEdgePanGestures()
    }

    ///Create the required gestures depending on the edges
    func makeEdgePanGestures() {
        edges.forEach { edge in
            let panGesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                              action:
                #selector(CariocaGestureManager.panGestureEvent(_:)))
            panGesture.edges = edge
            hostView.addGestureRecognizer(panGesture)
        }
    }
    ///Pan gesture event received
    /// - Parameter gesture: UIPanGestureRecognizer
    @objc func panGestureEvent(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: gesture.view)
        if gesture.state == .changed {
            CariocaMenu.log("PAN: changed \(Double(location.y))")
        }
        if gesture.state == .ended { }
        if gesture.state == .failed { CariocaMenu.log("Failed : \(gesture)") }
        if gesture.state == .possible { CariocaMenu.log("Possible : \(gesture)") }
        if gesture.state == .cancelled { CariocaMenu.log("cancelled : \(gesture)") }
    }
}

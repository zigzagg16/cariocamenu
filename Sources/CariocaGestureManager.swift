//
//  CariocaGestureManager.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

class CariocaGestureManager {

    let hostView: UIView
    let controller: CariocaController
    let edges: [UIRectEdge]
    ///The edge gestures
    let edgePanGestures: [UIScreenEdgePanGestureRecognizer] = []

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

    @objc func panGestureEvent(_ gesture: UIGestureRecognizer) {
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

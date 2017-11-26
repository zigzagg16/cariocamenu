//
//  CariocaGestureManagerTests.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 26/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import XCTest
import CariocaMenu

class CariocaGestureManagerTests: XCTestCase {

    func testTopConstraintCalculation() {
        //Given
        var yLocation: CGFloat = 40.0
        var originalScreenEdgePanY: CGFloat = 342.0
        let menuHeight: CGFloat = 240.0
        let heightForRow: CGFloat = 60.0
        var selectedIndex: Int = 1
        var yRange: ClosedRange<CGFloat> = 20.0...700
        var isOffScreenAllowed: Bool = true
        func position() -> CGFloat {
            return CariocaGestureManager.topYConstraint(yLocation: yLocation,
                                                 originalScreeenEdgePanY: originalScreenEdgePanY,
                                                 menuHeight: menuHeight, heightForRow: heightForRow,
                                                 selectedIndex: selectedIndex,
                                                 yRange: yRange,
                                                 isOffscreenAllowed: isOffScreenAllowed)
        }
        //When
        let yPosition1 = position()
        selectedIndex = 3
        originalScreenEdgePanY = 50
        let yPosition2 = position()
        originalScreenEdgePanY = 600
        isOffScreenAllowed = false
        let yPosition3 = position()
        
        //Then
        XCTAssertEqual(yPosition1, CGFloat(614.00), accuracy: 0.001)
        XCTAssertEqual(yPosition2, CGFloat(-90.00), accuracy: 0.001)
        XCTAssertEqual(yPosition3, CGFloat(700.00), accuracy: 0.001)
    }
}

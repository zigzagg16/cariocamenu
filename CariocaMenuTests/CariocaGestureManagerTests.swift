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
        XCTAssertEqual(yPosition1, CGFloat(554.00), accuracy: 0.001)
        XCTAssertEqual(yPosition2, CGFloat(-150.00), accuracy: 0.001)
        XCTAssertEqual(yPosition3, CGFloat(700.00), accuracy: 0.001)
    }

    func testMatchingIndexCalculation() {
        //Given
        var yLocation: CGFloat = 40.0
        var menuYPosition: CGFloat = 342.0
        let heightForRow: CGFloat = 60.0
        var numberOfMenuItems: Int = 10

        func index() -> Int {
            return CariocaGestureManager.matchingIndex(yLocation: yLocation,
                                                       menuYPosition: menuYPosition,
                                                       heightForRow: heightForRow,
                                                       numberOfMenuItems: numberOfMenuItems)
        }
        //When
        let index1 = index()
        menuYPosition = 290.0
        yLocation = 390.0
        let index2 = index()

        //Then
        XCTAssertEqual(index1, 0)
        XCTAssertEqual(index2, 1)
    }
}

//
//  CariocaIndicatorViewTests.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 26/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import XCTest
import CariocaMenu

class CariocaIndicatorViewTests: XCTestCase {

	let hostWidth: CGFloat = 300.0
	let indicatorWidth: CGFloat = 50.0
	var edge: UIRectEdge = .left
	var borderMargin: CGFloat = 5.0
	var bouncingValues: BouncingValues = (from: 15.0, to: 5.0)
	var startInset: CGFloat = 44.0
	var endInset: CGFloat = 44.0

    func testPositionsCalculationLeft() {
        //Given
		//All initial variable values
		//When
		let positions = calculatePositions()
        //Then
//		print(positions.start)
		print(positions)
//        XCTAssertEqual(yPosition1, CGFloat(554.00), accuracy: 0.001)
    }

	func testPositionsCalculationRight() {
		//Given
		//When
		let positions = calculatePositions()
		//Then
	}

	func testPositionsCalculationiPhoneXLeft() {
		//Given
		//When
		let positions = calculatePositions()
		//Then
	}

	private func calculatePositions() -> IndicatorPositionConstants {
		return CariocaIndicatorView.positionConstants(hostWidth: hostWidth,
													  indicatorWidth: indicatorWidth,
													  edge: edge,
													  borderMargin: borderMargin,
													  bouncingValues: bouncingValues,
													  startInset: startInset,
													  endInset: endInset)
	}
}

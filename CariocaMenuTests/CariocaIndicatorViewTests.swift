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

	let hostWidth: CGFloat = 375.0
	let indicatorWidth: CGFloat = 50.0
	var edge: UIRectEdge = .left
	var borderMargin: CGFloat = 5.0
	var bouncingValues: BouncingValues = (from: 15.0, to: 5.0)
	var startInset: CGFloat = 0.0
	var endInset: CGFloat = 0.0

    func testPositionsCalculationLeft() {
        //Given
		startInset = 0.0
		endInset = 0.0
		edge = .left
		//When
		let positions = calculatePositions()
        //Then
		XCTAssertEqual(positions.start, -167.5)
		XCTAssertEqual(positions.startBounce.from, -182.5)
		XCTAssertEqual(positions.startBounce.to, -162.5)
		XCTAssertEqual(positions.end.from, 177.5)
		XCTAssertEqual(positions.end.to, 157.5)
		XCTAssertEqual(positions.hidingConstant, 237.5)
    }

	func testPositionsCalculationRight() {
		//Given
		startInset = 0.0
		endInset = 0.0
		edge = .right
		//When
		let positions = calculatePositions()
		//Then
		XCTAssertEqual(positions.start, 167.5)
		XCTAssertEqual(positions.startBounce.from, 182.5)
		XCTAssertEqual(positions.startBounce.to, 162.5)
		XCTAssertEqual(positions.end.from, -177.5)
		XCTAssertEqual(positions.end.to, -157.5)
		XCTAssertEqual(positions.hidingConstant, -237.5)
	}

	func testPositionsCalculationiPhoneX() {
		//Given
		startInset = 44.0
		endInset = 44.0
		edge = .left
		//When
		let left = calculatePositions()
		edge = .right
		let right = calculatePositions()
		//Then
		XCTAssertEqual(left.start, -123.5)
		XCTAssertEqual(left.startBounce.from, -182.5)
		XCTAssertEqual(left.startBounce.to, -118.5)
		XCTAssertEqual(left.end.from, 221.5)
		XCTAssertEqual(left.end.to, 113.5)
		XCTAssertEqual(left.hidingConstant, 237.5)
		XCTAssertEqual(right.start, 123.5)
		XCTAssertEqual(right.startBounce.from, 182.5)
		XCTAssertEqual(right.startBounce.to, 118.5)
		XCTAssertEqual(right.end.from, -221.5)
		XCTAssertEqual(right.end.to, -113.5)
		XCTAssertEqual(right.hidingConstant, -237.5)
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

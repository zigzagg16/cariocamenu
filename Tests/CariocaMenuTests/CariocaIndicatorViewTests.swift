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
		XCTAssertEqual(positions.start, -5.0)
		XCTAssertEqual(positions.startBounce.from, -20.0)
		XCTAssertEqual(positions.startBounce.to, 0.0)
		XCTAssertEqual(positions.end.from, 265.0)
		XCTAssertEqual(positions.end.to, 245.0)
		XCTAssertEqual(positions.secondConstant, -5.0)
    }

	func testPositionsCalculationRight() {
		//Given
		startInset = 0.0
		endInset = 0.0
		edge = .right
		//When
		let positions = calculatePositions()
		//Then
		XCTAssertEqual(positions.start, 5.0)
		XCTAssertEqual(positions.startBounce.from, 20.0)
		XCTAssertEqual(positions.startBounce.to, 0.0)
		XCTAssertEqual(positions.end.from, -265.0)
		XCTAssertEqual(positions.end.to, -245.0)
		XCTAssertEqual(positions.secondConstant, 5.0)
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
		XCTAssertEqual(left.start, 39.0)
		XCTAssertEqual(left.startBounce.from, 68.0)
		XCTAssertEqual(left.startBounce.to, 44.0)
		XCTAssertEqual(left.end.from, 309.0)
		XCTAssertEqual(left.end.to, 201.0)
		XCTAssertEqual(left.secondConstant, -49.0)
		XCTAssertEqual(right.start, -39.0)
		XCTAssertEqual(right.startBounce.from, 20.0)
		XCTAssertEqual(right.startBounce.to, -44.0)
		XCTAssertEqual(right.end.from, -309.0)
		XCTAssertEqual(right.end.to, -201.0)
		XCTAssertEqual(right.secondConstant, 49.0)
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

//
//  CariocaMenuIndicatorView.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 01/12/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

///The indicator configuration
public typealias CariocaIndicator = UIView & CariocaIndicatorConfiguration

///Required parameters to create a custom indicator view
public protocol CariocaIndicatorConfiguration {
	///The shape's color
	var color: UIColor { get }
	///The font used to display emojis/string
	var font: UIFont { get }
	///The shape's size
	var size: CGSize { get }
	///The margin to the screen
	var borderMargin: CGFloat { get }
	///The bouncing values used for animation
	var bouncingValues: BouncingValues { get }
	///The custom shape of the view
	func shape(for edge: UIRectEdge, frame: CGRect) -> UIBezierPath
	///The margins for the icon, depending on the edge
	func iconMargins(for edge: UIRectEdge) -> (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat)
}
public extension CariocaIndicatorConfiguration {
	///Default margins are 0,0,0,0
	func iconMargins(for edge: UIRectEdge) -> (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
		return (top: 0.0, right: 0.0, bottom: 0.0, left: 0.0)
	}
	///Default size
	var size: CGSize { return CGSize(width: 50, height: 40) }
	///Default border margin
	var borderMargin: CGFloat { return 7.5 }
	///Default color
	var color: UIColor { return UIColor(red: 0.23, green: 0.60, blue: 0.85, alpha: 1.00) }
	///Default bouncing values
	var bouncingValues: BouncingValues { return (from: 15.0, to: 5.0) }
	///Default font
	var font: UIFont { return UIFont.boldSystemFont(ofSize: 20.0) }

	func shape(for edge: UIRectEdge, frame: CGRect) -> UIBezierPath {
		//This shape was drawed with PaintCode App
		let ovalPath = UIBezierPath()
		if edge == .left {
			ovalPath.move(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.minY),
							  controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.22 * frame.height),
							  controlPoint2: CGPoint(x: frame.maxX - 9, y: frame.minY))
			ovalPath.addCurve(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.maxX - 31, y: frame.minY),
							  controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 0.3 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.maxY),
							  controlPoint1: CGPoint(x: frame.minX, y: frame.minY + 0.7 * frame.height),
							  controlPoint2: CGPoint(x: frame.maxX - 31, y: frame.maxY))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.maxX - 9, y: frame.maxY),
							  controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.78 * frame.height))
		} else { //right
			ovalPath.move(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.minX + 20, y: frame.minY),
							  controlPoint1: CGPoint(x: frame.minX, y: frame.minY + 0.22 * frame.height),
							  controlPoint2: CGPoint(x: frame.minX + 9, y: frame.minY))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.minX + 31, y: frame.minY),
							  controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.3 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.minX + 20, y: frame.maxY),
							  controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.7 * frame.height),
							  controlPoint2: CGPoint(x: frame.minX + 31, y: frame.maxY))
			ovalPath.addCurve(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.minX + 9, y: frame.maxY),
							  controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 0.78 * frame.height))
		}
		ovalPath.close()
		return ovalPath
	}
}

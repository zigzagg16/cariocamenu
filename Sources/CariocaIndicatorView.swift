//
//  CariocaMenuIndicatorView.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 01/12/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

///The indicator initial position
public enum CariocaIndicatorPosition {
	///Top position, with offset option
	case top(CGFloat)
	///Center position, with offset option
	case center(CGFloat)
	///Bottom position, with offset option
	case bottom(CGFloat)
}

///Defines bouncing values for animation from/to
typealias BouncingValues = (from: CGFloat, to: CGFloat)

///The constants that will be used to animate the indicator
struct IndicatorPositionConstants {
	///Starting position constant (indicator on hold)
	let start: CGFloat
	///Starting position bouncing values
	let startBounce: BouncingValues
	///Ending position bouncing values
	let end: BouncingValues
}
///The menu's indicator
public class CariocaIndicatorView: UIView {
	///The edge of the indicator.
	var edge: UIRectEdge
	///The indicator's color
	var color: UIColor
	///The indicator's top constraint
	var topConstraint = NSLayoutConstraint()
	///The indicator's leading/left constraint.
	///Depending on the edge, the priority will be switched w/ trailingConstraint
	var leadingConstraint = NSLayoutConstraint()
	///The indicator's trailing/right constraint.
	///Depending on the edge, the priority will be switched w/ leadingConstraint
	var trailingConstraint = NSLayoutConstraint()
	///The icon's view
	var iconView: CariocaIconView
	///The border space.
	let borderMargin: CGFloat
	///The bouncing value
	let bouncingValues: BouncingValues

	///Initialise an IndicatorView
	///- Parameter edge: The inital edge. Will be updated every time the user changes of edge.
	///- Parameter size: The view's size
	///- Parameter color: The view's shape color
	init(edge: UIRectEdge,
		 size: CGSize = CGSize(width: 47, height: 40),
		 color: UIColor = UIColor(red: 0.07, green: 0.73, blue: 0.86, alpha: 1),
		 borderSpace: CGFloat = 5.0,
		 bouncingValues: BouncingValues = (from: 15.0, to: 5.0)) {
		self.edge = edge
		self.color = color
		self.borderMargin = borderSpace
		self.bouncingValues = bouncingValues
		self.iconView = CariocaIconView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		self.iconView.translatesAutoresizingMaskIntoConstraints = false
		let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.addSubview(iconView)
		self.addConstraints(iconView.makeAnchorConstraints(to: self))
	}

	///Calculates the indicator's position for animation
	///- Parameter hostSize: The hostView's size
	///- Parameter indicatorSize: The indicator's size
	///- Parameter edge: The original edge
	///- Parameter borderMargin: The border magins
	///- Parameter bouncingValues: The values to make the bouncing effect in animations
	///- Returns: IndicatorPositionConstants All the possible calculated positions
	private func positionConstants(hostWidth: CGFloat,
								   indicatorWidth: CGFloat,
								   edge: UIRectEdge,
								   borderMargin: CGFloat,
								   bouncingValues: BouncingValues) -> IndicatorPositionConstants {
		let multiplier: CGFloat = edge == .left ? 1.0 : -1.0
		let inverseMultiplier: CGFloat = multiplier * -1.0
		//Start positions
		let start = borderMargin * inverseMultiplier
		let startBounceFrom = start + (bouncingValues.from * inverseMultiplier)
		let startBounceTo = start + (bouncingValues.to * multiplier)
		let startBounce: BouncingValues = (from: startBounceFrom, to: startBounceTo)
		//End positions
		let endBounceFrom: CGFloat = (hostWidth - indicatorWidth + bouncingValues.from) * multiplier
		let endBounceTo: CGFloat = (hostWidth - indicatorWidth - borderMargin) * multiplier
		let endBounce: BouncingValues = (from: endBounceFrom, to: endBounceTo)

		return IndicatorPositionConstants(start: start, startBounce: startBounce, end: endBounce)
	}

	///Adds the indicator in the hostView
	///- Parameter hostView: the menu's hostView
	///- Parameter tableView: the menu's tableView
	func addIn(_ hostView: UIView,
			   tableView: UITableView) {
		self.translatesAutoresizingMaskIntoConstraints = false
		hostView.addSubview(self)
		topConstraint = CariocaMenu.equalConstraint(self, toItem: tableView, attribute: .top)
		leadingConstraint = makeHorizontalConstraint(hostView, .leading)
		trailingConstraint = makeHorizontalConstraint(hostView, .trailing)
		//This priority setting call will be overrided later, in show().
		constraintPriorities(main: leadingConstraint, second: trailingConstraint)
		hostView.addConstraints([
			NSLayoutConstraint(item: self,
							   attribute: .width, relatedBy: .equal,
							   toItem: nil, attribute: .notAnAttribute,
							   multiplier: 1, constant: frame.size.width),
			NSLayoutConstraint(item: self,
							   attribute: .height, relatedBy: .equal,
							   toItem: nil, attribute: .notAnAttribute,
							   multiplier: 1, constant: frame.size.height),
			topConstraint,
			leadingConstraint,
			trailingConstraint
		])
	}

	///Create the horizontal constraint
	///- Parameter hostView: The menu's hostView
	///- Parameter attribute: The layoutAttribute for the constraint
	///- Parameter priority: The constraint's priority
	///- Returns: NSLayoutConstraint the horizontal constraint
	private func makeHorizontalConstraint(_ hostView: UIView,
										  _ attribute: NSLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self,
								  attribute: attribute, relatedBy: .equal,
								  toItem: hostView, attribute: attribute,
								  multiplier: 1, constant: 0.0)
	}

	///Draws the shape, depending on the edge.
	///- Parameter frame: The IndicatorView's frame
	override public func draw(_ frame: CGRect) {
		self.backgroundColor = .clear
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
		} else {
			//right
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
		color.setFill()
		ovalPath.fill()
	}

	///Show the indicator on a specific edge, by animating the horizontal position
	///- Parameter edge: The screen edge
	///- Parameter hostView: The menu's hostView, to calculate the positions
	///- Parameter isTraversingView: Should the indicator traverse the hostView, and stick to the opposite edge ?
	func show(edge: UIRectEdge, hostView: UIView, isTraversingView: Bool) {
		self.edge = edge
		self.setNeedsDisplay()
		let positions = positionConstants(hostWidth: hostView.frame.width,
										  indicatorWidth: frame.width,
										  edge: edge,
										  borderMargin: borderMargin,
										  bouncingValues: bouncingValues)
		let mainConstraint = edge == .left ? leadingConstraint : trailingConstraint
		let secondConstraint = edge == .left ? trailingConstraint : leadingConstraint
		constraintPriorities(main: mainConstraint, second: secondConstraint)
		mainConstraint.constant = positions.startBounce.from
		superview?.layoutIfNeeded()
		if isTraversingView {
			secondConstraint.constant = positions.start
		}
		let animationValueOne = isTraversingView ? positions.end.from : positions.startBounce.to
		let animationValueTwo = isTraversingView ? positions.end.to : positions.start

		animate(mainConstraint,
				positionOne: animationValueOne,
				timingOne: isTraversingView ? 0.3 : 0.15,
				positionTwo: animationValueTwo,
				finished: {
					if isTraversingView {
						self.constraintPriorities(main: secondConstraint, second: mainConstraint)
					}
		})
	}

	///Retore the indicator on it's original edge position
	///- Parameter hostView: The menu's hostView, to calculate the positions
	func restore(hostView: UIView) {
		let positions = positionConstants(hostWidth: hostView.frame.width,
										  indicatorWidth: frame.width,
										  edge: edge,
										  borderMargin: borderMargin,
										  bouncingValues: bouncingValues)
		let mainConstraint = edge == .left ? leadingConstraint : trailingConstraint
		let secondConstraint = edge == .left ? trailingConstraint : leadingConstraint
		constraintPriorities(main: mainConstraint, second: secondConstraint)
		animate(mainConstraint,
				positionOne: positions.startBounce.from,
				timingOne: 0.4,
				positionTwo: positions.start,
				finished: {})
	}

	///Animate a constraint two times, on two different values
	///- Parameter constraint: The constraint to animate
	///- Parameter positionOne: The first constant to animate
	///- Parameter timingOne: The first animation duration
	///- Parameter positionTwo: The second constant to animate
	///- Parameter timingTwo: The second animation duration
	///- Parameter finished: Completion closure, when both animations finished
	internal func animate(_ constraint: NSLayoutConstraint,
						  positionOne: CGFloat,
						  timingOne: Double =  0.15,
						  positionTwo: CGFloat,
						  timingTwo: Double =  0.25,
						  finished: @escaping () -> Void) {
		constraint.constant = positionOne
		UIView.animate(withDuration: timingOne,
					   delay: 0,
					   options: [.curveEaseIn],
					   animations: {
						self.superview?.layoutIfNeeded()
		}, completion: { _ in
			constraint.constant = positionTwo
			UIView.animate(withDuration: timingTwo,
						   delay: 0,
						   options: [.curveEaseOut],
						   animations: {
							self.superview?.layoutIfNeeded()
			}, completion: { _ in
				finished()
			})
		})
	}

	///Utility to inverse 2 constraint priorities
	///- Parameter main: The highest priority will be applied to that constraint.
	///- Parameter second: The lowest priority will be applied to that constraint.
	internal func constraintPriorities(main: NSLayoutConstraint,
									   second: NSLayoutConstraint) {
		main.priority = UILayoutPriority(100.0)
		second.priority = UILayoutPriority(50.0)
	}

	///Move the indicator to a specific index, by updating the top constraint value
	///- Parameter index: The selection index of the menu, where the indicator will appear
	///- Parameter heightForRow: The height of each menu item
	func moveTo(index: Int, heightForRow: CGFloat) {
		topConstraint.constant = (CGFloat(index) * heightForRow) + ((heightForRow - frame.size.height) / 2.0)
		superview?.layoutIfNeeded()
	}

	///:nodoc:
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

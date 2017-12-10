//
//  CariocaMenuIndicatorView.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 01/12/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

///Defines bouncing values for animation from/to
public typealias BouncingValues = (from: CGFloat, to: CGFloat)

///The constants that will be used to animate the indicator
struct IndicatorPositionConstants {
	///Starting position constant (indicator on hold)
	let start: CGFloat
	///Starting position bouncing values
	let startBounce: BouncingValues
	///Ending position bouncing values
	let end: BouncingValues
	///The value of the secondary constraint's constant, when the indicator is showed.
	///The secondary constant will be prioritary only when the menu is opened.
	let secondConstant: CGFloat
	///The value to hide the menu, when restoring the boomerang.
	let hidingConstant: CGFloat
}

///The menu's indicator
public class CariocaIndicatorView: UIView {
	///The edge of the indicator.
	var edge: UIRectEdge
	///The original edge. Used when boomerang is not .none
	private let originalEdge: UIRectEdge
	///The indicator's top constraint
	var topConstraint = NSLayoutConstraint()
	///The indicator's leading/left constraint.
	///Depending on the edge, the priority will be switched w/ trailingConstraint
	private var leadingConstraint = NSLayoutConstraint()
	///The indicator's trailing/right constraint.
	///Depending on the edge, the priority will be switched w/ leadingConstraint
	private var trailingConstraint = NSLayoutConstraint()
	///The icon's view
	var iconView: CariocaIconView
	///The custom indicator configuration
	private let config: CariocaIndicator
	///The constraints applied to the iconview. Can be updated later with custom configuration
	private var iconConstraints: [NSLayoutConstraint] = []

	///Initialise an IndicatorView
	///- Parameter edge: The inital edge. Will be updated every time the user changes of edge.
	///- Parameter indicator: The indicator custom configuration
	init(edge: UIRectEdge, indicator: CariocaIndicator) {
		self.edge = edge
		self.originalEdge = edge
		self.config = indicator
		self.iconView = CariocaIconView()
		self.iconView.translatesAutoresizingMaskIntoConstraints = false
		let frame = CGRect(x: 0, y: 0, width: indicator.size.width, height: indicator.size.height)
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.addSubview(iconView)
		iconConstraints = iconView.makeAnchorConstraints(to: self)
		self.addConstraints(iconConstraints)
		iconView.font = config.font
	}

	//swiftlint:disable function_parameter_count
	///Calculates the indicator's position for animation
	///- Parameter hostWidth: The hostView's width
	///- Parameter indicatorWidth: The indicator's size
	///- Parameter edge: The original edge
	///- Parameter borderMargin: The border magins
	///- Parameter bouncingValues: The values to make the bouncing effect in animations
	///- Parameter startInset: The view's starting inset, if applies (iPhone X safe area)
	///- Parameter endInset: The view's starting inset, if applies (iPhone X safe area)
	///- Returns: IndicatorPositionConstants All the possible calculated positions
	class func positionConstants(hostWidth: CGFloat,
								 indicatorWidth: CGFloat,
								 edge: UIRectEdge,
								 borderMargin: CGFloat,
								 bouncingValues: BouncingValues,
								 startInset: CGFloat,
								 endInset: CGFloat) -> IndicatorPositionConstants {
		let multiplier: CGFloat = edge == .left ? 1.0 : -1.0
		let inverseMultiplier: CGFloat = multiplier * -1.0
		//Start positions
		let start = (borderMargin - startInset) * inverseMultiplier
		let startBounceFrom = start + (bouncingValues.from * inverseMultiplier) + startInset
		let startBounceTo = start + (bouncingValues.to * multiplier)
		let startBounce: BouncingValues = (from: startBounceFrom, to: startBounceTo)
		//End positions
		let endBounceFrom: CGFloat = (hostWidth - indicatorWidth + bouncingValues.from + endInset) * multiplier
		let endBounceTo: CGFloat = (hostWidth - indicatorWidth - borderMargin - endInset) * multiplier
		let endBounce: BouncingValues = (from: endBounceFrom, to: endBounceTo)
		///Second constant value calculation
		let secondConstant: CGFloat = (endInset + borderMargin) * inverseMultiplier
		///Hiding constant
		let hidingConstant = (indicatorWidth * 2.0) * multiplier
		return IndicatorPositionConstants(start: start, startBounce: startBounce,
										  end: endBounce,
										  secondConstant: secondConstant,
										  hidingConstant: hidingConstant)
	}
	//swiftlint:enable function_parameter_count

	///Adds the indicator in the hostView
	///- Parameter hostView: the menu's hostView
	///- Parameter tableView: the menu's tableView
	///- Parameter position: the indicator initial position in %
	func addIn(_ hostView: UIView,
			   tableView: UITableView,
			   position: CGFloat) {
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
		topConstraint.constant = verticalConstant(for: position,
												  hostHeight: hostView.frame.height,
												  height: frame.height)
	}

	///Moves the indicator after rotation, at 50%, to be centered
	///- Parameter hostView: the menu's hostView
	///- Parameter position: the indicator initial position in %
	func moveAfterRotation(_ hostView: UIView, position: CGFloat) {
		topConstraint.constant = verticalConstant(for: position,
												  hostHeight: hostView.frame.height,
												  height: frame.height)
	}

	///Calculates the Y constraint based on percentage.
	///A margin of 50% of the indicator view is applied for security.
	///- Parameter percentage: The desired position percentage
	///- Parameter hostHeight: The host's height
	///- Parameter height: The indicator's height
	///- Returns: CGFloat: The constant calculated Y value
	private func verticalConstant(for percentage: CGFloat,
								  hostHeight: CGFloat,
								  height: CGFloat) -> CGFloat {
		let demiHeight = height / 2.0
		let min = demiHeight
		let max = hostHeight - (height + demiHeight)
		let desiredPosition = ((hostHeight / 100.0) * percentage) - demiHeight
		//Check the minimum/maximum
		return desiredPosition < min ? min : desiredPosition > max ? max : desiredPosition
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
		applyMarginConstraints(margins: config.iconMargins(for: edge))
		let ovalPath = config.shape(for: edge, frame: frame)
		config.color.setFill()
		ovalPath.fill()
	}

	///Applies the margins to the iconView
	///- Parameter margins: Tuple of margins in CSS Style (Top, Right, Bottom, left)
	private func applyMarginConstraints(margins: (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat)) {
		iconConstraints[0].constant = margins.top
		iconConstraints[1].constant = margins.right
		iconConstraints[2].constant = margins.bottom
		iconConstraints[3].constant = margins.left
		setNeedsLayout()
	}

	///The main constraint, with the highest priority. Depends on the current edge.
	private var mainConstraint: NSLayoutConstraint {
		return edge == .left ? leadingConstraint : trailingConstraint
	}
	///The second constraint, with the lowest priority. Depends on the current edge.
	private var secondConstraint: NSLayoutConstraint {
		return edge == .left ? trailingConstraint : leadingConstraint
	}
	///Calls the positionConstants() with all internal parameters
	///- Returns: IndicatorPositionConstants All the possible calculated positions
	private func positionValues(_ hostView: UIView) -> IndicatorPositionConstants {
		let insets = insetsValues(hostView.insets(),
								  orientation: UIDevice.current.orientation,
								  edge: edge)
		return CariocaIndicatorView.positionConstants(hostWidth: hostView.frame.width,
													  indicatorWidth: frame.width,
													  edge: edge,
													  borderMargin: config.borderMargin,
													  bouncingValues: config.bouncingValues,
													  startInset: insets.start,
													  endInset: insets.end)
	}

	///When the hostView has rotated, re-apply the constraints.
	///This should have an effect only on iPhone X, because of the view edges.
	///- Parameter hostView: The menu's hostView
	func repositionXAfterRotation(_ hostView: UIView) {
		let positions = positionValues(hostView)
		mainConstraint.constant = positions.start
		secondConstraint.constant = positions.secondConstant
	}

	///Calculates inset values, depending on orientation.
	///The goal is to only have the inset on the indicator when the edge of the indicator is on the side of the notch.
	///- Parameter insets: The original insets
	///- Parameter orientation: The screen orientation
	///- Parameter edge: The screen edge
	///- Returns: Start end End insets for the indicator.
	func insetsValues(_ insets: UIEdgeInsets,
					  orientation: UIDeviceOrientation,
					  edge: UIRectEdge) -> (start: CGFloat, end: CGFloat) {
		var startInset = edge == .left ? insets.left : insets.right
		let endInset = edge == .left ? insets.right : insets.left
		if (orientation == .landscapeLeft && edge == .right) ||  //The notch is on the left side
			(orientation == .landscapeRight && edge == .left) { //The notch is on the right side
			startInset = 0.0
		}
		//Special case to not put the at the notch level
		//35.0 is the limit of the notch.
		startInset = startInset == 44.0 ? (35.0 - config.borderMargin) : startInset
		return (start: startInset, end: endInset)
	}

	///Show the indicator on a specific edge, by animating the horizontal position
	///- Parameter edge: The screen edge
	///- Parameter hostView: The menu's hostView, to calculate the positions
	///- Parameter isTraversingView: Should the indicator traverse the hostView, and stick to the opposite edge ?
	func show(edge: UIRectEdge, hostView: UIView, isTraversingView: Bool) {
		guard let superView = self.superview else { return }
		self.edge = edge
		self.setNeedsDisplay()
		let positions = positionValues(hostView)
		constraintPriorities(main: mainConstraint, second: secondConstraint)
		mainConstraint.isActive = true
		secondConstraint.isActive = true
		mainConstraint.constant = positions.startBounce.from
		superview?.layoutIfNeeded()
		let animationValueOne = isTraversingView ? positions.end.from : positions.startBounce.to
		let animationValueTwo = isTraversingView ? positions.end.to : positions.start

		animation(superView, constraint: mainConstraint,
				  constant: animationValueOne, timing: isTraversingView ? 0.3 : 0.15, options: [.curveEaseIn], finished: {
					self.animation(superView, constraint: self.mainConstraint,
								   constant: animationValueTwo, timing: 0.2, options: [.curveEaseOut], finished: {
									if isTraversingView {
									self.secondConstraint.constant = positions.secondConstant
									self.constraintPriorities(main: self.secondConstraint,
															  second: self.mainConstraint)
									}
					})
		})
	}
	///Retore the indicator on it's original edge position
	///- Parameter hostView: The menu's hostView, to calculate the positions
	///- Parameter boomerang: The boomerang type to restore the indicator
	///- Parameter initialPosition: The indicator initial position
	///- Parameter firstStepDone: Called when the first animation is complete, with or without boomerang.
	func restore(hostView: UIView,
				 boomerang: BoomerangType,
				 initialPosition: CGFloat,
				 firstStepDone: @escaping () -> Void) {
		let hasBoomerang = boomerang == .vertical || boomerang == .verticalAndHorizontal
		let positions = positionValues(hostView)
		var positionOne: CGFloat
		var positionTwo: CGFloat
		var mustSwitchEdge = false //Will the indicator switch of edge ?
		if hasBoomerang { //Boomerang logic
			//the indicator must go out of the view
			constraintPriorities(main: secondConstraint, second: mainConstraint)
			mainConstraint.isActive = false
			secondConstraint.isActive = true
			positionOne = positions.hidingConstant
			positionTwo = positions.hidingConstant
			mustSwitchEdge = self.originalEdge != self.edge
		} else {
			constraintPriorities(main: mainConstraint, second: secondConstraint)
			mainConstraint.isActive = true
			secondConstraint.isActive = false
			positionOne = positions.startBounce.from
			positionTwo = positions.start
		}
		let constraintToAnimate = hasBoomerang ? secondConstraint : mainConstraint
		animation(superview!, constraint: constraintToAnimate,
				  constant: positionOne, timing: 0.4, options: [.curveEaseIn], finished: {
					if hasBoomerang {
						firstStepDone()
						print("mustSwitchEdge \(mustSwitchEdge)")
						return
					} else {
						self.animation(self.superview!, constraint: constraintToAnimate,
									   constant: positionTwo, timing: 0.3, options: [.curveEaseOut], finished: {
										firstStepDone()
						})
					}
		})
	}

	// swiftlint:disable function_parameter_count
	///Animate a constraint
	///- Parameter view: The view to layoutIfNeeded
	///- Parameter constraint: The constraint to animate
	///- Parameter constant: The new constant value
	///- Parameter timing: The animation duration
	///- Parameter options: The animation options
	///- Parameter finished: Completion closure, when animation finished
	internal func animation(_ view: UIView,
							constraint: NSLayoutConstraint,
							constant: CGFloat,
							timing: Double,
							options: UIViewAnimationOptions,
							finished: @escaping () -> Void) {
		constraint.constant = constant
		UIView.animate(withDuration: timing, delay: 0.0, options: options, animations: {
			view.layoutIfNeeded()
		}, completion: { _ in
			finished()
		})
	}
	// swiftlint:enable function_parameter_count

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

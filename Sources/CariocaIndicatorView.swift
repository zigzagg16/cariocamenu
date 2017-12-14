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
	///The indicator's horizontal constraint.
	private var horizontalConstraint = NSLayoutConstraint()
	///The icon's view
	var iconView: CariocaIconView
	///The custom indicator configuration
	private let config: CariocaIndicator
	///The constraints applied to the iconview. Can be updated later with custom configuration
	private var iconConstraints: [NSLayoutConstraint] = []
	///The indicator's possible animation states
	private enum AnimationState {
		///The indicator is on hold, the menu is closed
		case onHold
		///The indicator is performing showing animation
		case showing
		///The indicator is performing restoration animation
		case restoring
	}
	///Status of the indicator animations. Avoid double animations issues
	private var state: AnimationState = .onHold
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
		let multiplier: CGFloat = edge == .left ? -1.0 : 1.0
		let hostMidWidth = hostWidth / 2.0
		let indicWidth = indicatorWidth / 2.0
		let inverseMultiplier: CGFloat = multiplier * -1.0
		//Start positions
		let start = hostMidWidth - indicWidth + borderMargin - startInset
		let startBounceFrom = start + bouncingValues.from + startInset
		let startBounceTo = start - bouncingValues.to
		let startBounce: BouncingValues = (from: (startBounceFrom * multiplier), to: (startBounceTo * multiplier))
		//End positions
		let endBounceFrom: CGFloat = (hostMidWidth - indicWidth + bouncingValues.from + endInset) * inverseMultiplier
		let endBounceTo: CGFloat = (hostMidWidth - indicWidth - borderMargin - endInset) * inverseMultiplier
		let endBounce: BouncingValues = (from: endBounceFrom, to: endBounceTo)
		///Hiding constant
		let hidingConstant = (hostMidWidth + indicatorWidth) * inverseMultiplier
		return IndicatorPositionConstants(start: start * multiplier,
										  startBounce: startBounce,
										  end: endBounce,
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
		horizontalConstraint = makeHorizontalConstraint(hostView, NSLayoutAttribute.centerX)
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
			horizontalConstraint
		])
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
		horizontalConstraint.constant = positions.start
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
		self.state = .showing
		self.edge = edge
		self.setNeedsDisplay()
		let positions = positionValues(hostView)
		horizontalConstraint.constant = positions.startBounce.from
		superview?.layoutIfNeeded()
		let animationValueOne = isTraversingView ? positions.end.from : positions.startBounce.to
		let animationValueTwo = isTraversingView ? positions.end.to : positions.start

		animation(superView, constraint: horizontalConstraint,
				  constant: animationValueOne, timing: isTraversingView ? 0.3 : 0.15, options: [.curveEaseIn], finished: {
					guard self.state != .restoring else { return /*second show animation cancelled, indicator is restoring*/ }
					self.animation(superView, constraint: self.horizontalConstraint,
								   constant: animationValueTwo, timing: 0.2, options: [.curveEaseOut], finished: {
									self.state = .onHold
					})
		})
	}
	///Retore the indicator on it's original edge position
	///- Parameter hostView: The menu's hostView, to calculate the positions
	///- Parameter boomerang: The boomerang type to restore the indicator
	///- Parameter initialPosition: The indicator initial position
	///- Parameter firstStepDuration: Should equal the time to hide the menu. First animation is 70%, second 30%.
	///In boomerang mode, first animation is 125% of that value.
	///- Parameter firstStepDone: Called when the first animation is complete, with or without boomerang.
	func restore(hostView: UIView,
				 boomerang: BoomerangType,
				 initialPosition: CGFloat,
				 firstStepDuration: Double,
				 firstStepDone: @escaping () -> Void) {
		guard state != .restoring else { return }
		self.state = .restoring
		let hasBoomerang = boomerang != .none
		let positions = positionValues(hostView)
		var positionOne: CGFloat, mustSwitchEdge = false //Will the indicator switch of edge ?
		var timingAnim1: Double = firstStepDuration * 0.7, timingAnim2: Double = firstStepDuration * 0.3
		if hasBoomerang { //Boomerang logic
			//the indicator must go out of the view
			positionOne = positions.hidingConstant
			mustSwitchEdge = (boomerang == .horizontal || boomerang == .originalPosition) && originalEdge != edge
			timingAnim1 = firstStepDuration * 1.25
		} else {
			positionOne = positions.startBounce.from
		}
		animation(superview!, constraint: horizontalConstraint,
				  constant: positionOne, timing: timingAnim1, options: [.curveEaseIn], finished: {
					if hasBoomerang {
						firstStepDone()
						let edgeToShow = mustSwitchEdge ? self.edge.opposite() : self.edge
						if boomerang == .originalPosition || boomerang == .vertical {
							self.topConstraint.constant = self.verticalConstant(for: initialPosition,
																				hostHeight: hostView.frame.height,
																				height: self.frame.height)
						}
						self.state = .onHold
						self.show(edge: edgeToShow, hostView: hostView, isTraversingView: false)
					} else {
						self.animation(self.superview!, constraint: self.horizontalConstraint,
									   constant: positions.start, timing: timingAnim2, options: [.curveEaseOut], finished: {
										firstStepDone()
										self.state = .onHold
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
	internal func animation(_ view: UIView, constraint: NSLayoutConstraint,
							constant: CGFloat, timing: Double,
							options: UIViewAnimationOptions,
							finished: @escaping () -> Void) {
		constraint.constant = constant
		UIView.animate(withDuration: timing, delay: 0.0, options: options, animations: {
			view.layoutIfNeeded()
		}, completion: { _ in finished() })
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
	required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

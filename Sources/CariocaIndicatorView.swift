//
//  CariocaMenuIndicatorView.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 01/12/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

struct IndicatorPositionConstants {
	let start: CGFloat
}
///The menu's indicator
public class CariocaIndicatorView: UIView {

	///The edge of the indicator.
	var edge: UIRectEdge
	///The indicator's color
	var color: UIColor
	///The indicator's top constraint
	var topConstraint: NSLayoutConstraint?
	///The indicator's horizontal constraint
	var horizontalConstraint = NSLayoutConstraint()
	///The icon's view
	var iconView: CariocaIconView
	///The border space.
	let borderSpace: CGFloat

	///Initialise an IndicatorView
	///- Parameter edge: The inital edge. Will be updated every time the user changes of edge.
	///- Parameter size: The view's size
	///- Parameter color: The view's shape color
	init(edge: UIRectEdge,
		 size: CGSize = CGSize(width: 47, height: 40),
		 color: UIColor = UIColor(red: 0.07, green: 0.73, blue: 0.86, alpha: 1),
		 borderSpace: CGFloat = 5.0) {
		self.edge = edge
		self.color = color
		self.borderSpace = borderSpace
		self.iconView = CariocaIconView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		self.iconView.translatesAutoresizingMaskIntoConstraints = false
		let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.addSubview(iconView)
		self.addConstraints(iconView.makeAnchorConstraints(to: self))
	}

	private func positionConstants(hostFrame: CGRect,
								   indicatorFrame: CGRect,
								   edge: UIRectEdge,
								   borderSpace: CGFloat) -> IndicatorPositionConstants {
		print("INDICATOR POSITIONS")
		print(hostFrame)
		let multiplier: CGFloat = edge == .left ? 1.0 : -1.0
		let inverseMultiplier: CGFloat = multiplier * -1.0
		let midHostWidth: CGFloat = hostFrame.size.width / 2.0
		let midFrameWidth: CGFloat = indicatorFrame.size.width / 2.0

		let startPosition = (midHostWidth + midFrameWidth) * inverseMultiplier
		let beforeEndPosition = (midHostWidth - borderSpace) * multiplier
		let endPosition = (midHostWidth - midFrameWidth - borderSpace) * multiplier

		print("start \(startPosition)")
		print("beforeEnd \(beforeEndPosition)")
		print("End \(endPosition)")

		return IndicatorPositionConstants(start: 0.0)
	}

	///Adds the indicator in the hostView
	///- Parameter hostView: the menu's hostView
	///- Parameter tableView: the menu's tableView
	func addIn(_ hostView: UIView,
			   tableView: UITableView) {
		self.translatesAutoresizingMaskIntoConstraints = false
		hostView.addSubview(self)
		_ = positionConstants(hostFrame: hostView.frame, indicatorFrame: frame, edge: edge, borderSpace: borderSpace)

		let topConstraintItem = CariocaMenu.equalConstraint(self, toItem: tableView, attribute: .top)
		horizontalConstraint = makeHorizontalConstraint(tableView,
														layoutAttribute: CariocaIndicatorView.layoutAttribute(for: edge))

		hostView.addConstraints([
			NSLayoutConstraint(item: self,
							   attribute: .width, relatedBy: .equal,
							   toItem: nil, attribute: .notAnAttribute,
							   multiplier: 1, constant: frame.size.width),
			NSLayoutConstraint(item: self,
							   attribute: .height, relatedBy: .equal,
							   toItem: nil, attribute: .notAnAttribute,
							   multiplier: 1, constant: frame.size.height),
			topConstraintItem,
			horizontalConstraint
			])
		topConstraint = topConstraintItem
	}

	///Create the horizontal constraint
	///- Parameter tableView: The menu's tableView
	///- Parameter layoutAttribute: The layoutAttribute for the constraint
	///- Returns: NSLayoutConstraint the horizontal constraint
	private func makeHorizontalConstraint(_ tableView: UITableView,
										  layoutAttribute: NSLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self,
								  attribute: layoutAttribute,
								  relatedBy: .equal,
								  toItem: tableView,
								  attribute: layoutAttribute,
								  multiplier: 1,
								  constant: 0)
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
	///- Parameter tableView: The menu's tableView. The indicator top constraint will be attached to tableview's top.
	///- Parameter hostView: The menu's hostView, to who the constraints are added.
	func show(edge: UIRectEdge, tableView: UITableView, hostView: UIView) {
//		hostView.removeConstraint(horizontalC)
		let multiplier: CGFloat = edge == .left ? 1.0 : -1.0
		let inverseMultiplier: CGFloat = multiplier * -1.0
		let borderSpace: CGFloat = 5.0
		let midHostWidth: CGFloat = hostView.frame.size.width / 2.0
		let midFrameWidth: CGFloat = frame.size.width / 2.0

		let startPosition = (midHostWidth + midFrameWidth) * inverseMultiplier
		let beforeEndPosition = (midHostWidth - borderSpace) * multiplier
		let endPosition = (midHostWidth - midFrameWidth - borderSpace) * multiplier
		horizontalConstraint.constant = startPosition
		self.superview?.layoutIfNeeded()

		horizontalConstraint.constant = beforeEndPosition
		UIView.animate(withDuration: 0.2,
					   delay: 0,
					   options: [.curveEaseIn],
					   animations: {
						self.superview?.layoutIfNeeded()
		}, completion: { _ in
			self.horizontalConstraint.constant = endPosition
			UIView.animate(withDuration: 0.3,
						   delay: 0,
						   options: [.curveEaseOut],
						   animations: {
							self.superview?.layoutIfNeeded()
			}, completion: { _ in
				//TODO: Apply new constraint constant
				//change priority
			})
		})
		self.edge = edge
		self.setNeedsDisplay()
	}

	///Move the indicator to a specific index, by updating the top constraint value
	///- Parameter index: The selection index of the menu, where the indicator will appear
	///- Parameter heightForRow: The height of each menu item
	func moveTo(index: Int, heightForRow: CGFloat) {
		topConstraint?.constant = (CGFloat(index) * heightForRow) + ((heightForRow - frame.size.height) / 2.0)
	}

	///:nodoc:
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	///Get the matching NSLAyoutAttribute
	///- Parameter edge: The screen edge
	///- Returns: NSLayoutAttribute: The matching NSLayoutAttribute
	class func layoutAttribute(for edge: UIRectEdge) -> NSLayoutAttribute {
		return edge == .left ? .leading : .trailing
	}
}

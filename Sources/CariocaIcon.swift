//
//  CariocaIcon.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 06/12/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit

///The indicator various icon options
public enum CariocaIcon {
	///Emoji, but in reality it can be whatever string that fits in the view
	case emoji(String)
	///Image icon
	case icon(UIImage)
	///No icon
	case none
}
///Displays a CariocaIcon, whatever the type of icon
public class CariocaIconView: UIView {
	///The label to display emoji
	var label = UILabel()
	///The imageView, to display icons
	var imageView = UIImageView()
	///The label's font
	var font: UIFont = UIFont.boldSystemFont(ofSize: 16.0) {
		didSet {
			label.font = font
		}
	}

	///Initialises view
	///- Parameter frame: The view's frame
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	///:nodoc:
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	///:nodoc:
	private func commonInit() {
		translatesAutoresizingMaskIntoConstraints = false
		clipsToBounds = true
		label.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		addConstraints(label.makeAnchorConstraints(to: self))
		addSubview(imageView)
		addConstraints(imageView.makeAnchorConstraints(to: self))
		label.font = font
		label.textAlignment = .center
		label.textColor = .white
		imageView.contentMode = .scaleAspectFit
	}

	///Displays an icon in the view. Only the required subview (label/imageview/?) will be displayed.
	///Other views will be hidden, not removed.
	///- Parameter icon: The icon to display
	public func display(icon: CariocaIcon) {
		///:nodoc:
		func hide(_ labelHidden: Bool, _ imageHidden: Bool) {
			imageView.isHidden = imageHidden
			label.isHidden = labelHidden
		}
		switch icon {
		case let .emoji(emojiString):
			hide(false, true)
			label.text = emojiString
		case let .icon(image):
			hide(true, false)
			imageView.image = image
		case .none:
			hide(true, true)
		}
	}
}

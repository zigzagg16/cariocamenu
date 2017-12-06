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

public class CariocaIconView: UIView {
	var label: UILabel
	var labelConstraints: [NSLayoutConstraint] = []
	var imageView: UIImageView
	var imageViewConstraints: [NSLayoutConstraint] = []

	override init(frame: CGRect) {
		label = UILabel(frame: frame)
		imageView = UIImageView(frame: frame)
		super.init(frame: frame)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.imageView.contentMode = .scaleAspectFit
		self.clipsToBounds = true
		self.addSubview(label)
		self.addSubview(imageView)
		self.addConstraints(label.makeAnchorConstraints(to: self))
		self.addConstraints(imageView.makeAnchorConstraints(to: self))
	}

	func display(icon: CariocaIcon) {
		switch icon {
		case let .emoji(emojiString):
			label.text = emojiString
			imageView.isHidden = true
			label.isHidden = false
		case let .icon(image):
			imageView.image = image
			imageView.isHidden = false
			label.isHidden = true
		case .none:
			imageView.isHidden = true
			label.isHidden = true
		}
	}
	///:nodoc:
	required public convenience init?(coder aDecoder: NSCoder) {
		self.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
	}
}

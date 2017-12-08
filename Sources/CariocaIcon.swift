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
	var label = UILabel()
	var imageView = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		translatesAutoresizingMaskIntoConstraints = false
		clipsToBounds = true
		label.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		addConstraints(label.makeAnchorConstraints(to: self))
		addSubview(imageView)
		addConstraints(imageView.makeAnchorConstraints(to: self))
		label.textAlignment = .center
		imageView.contentMode = .scaleAspectFit
	}

	func display(icon: CariocaIcon) {
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

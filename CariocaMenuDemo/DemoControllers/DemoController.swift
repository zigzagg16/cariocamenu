//
//  DemoController.swift
//  CariocaMenuDemo
//
//  Created by Arnaud  on 12/12/2017
//

import UIKit

protocol DemoController: class {
	func add(in parentViewController: UIViewController)
	func remove()
	var menuController: CariocaController? { get set }
}

extension DemoController where Self: UIViewController {

	func add(in parentViewController: UIViewController) {
		parentViewController.addChildViewController(self)
		self.view.backgroundColor = .clear
		parentViewController.view.addSubview(self.view)
		parentViewController.view.addConstraints(self.view.makeAnchorConstraints(to: parentViewController.view))
		parentViewController.view.layoutIfNeeded()
		setNeedsStatusBarAppearanceUpdate()
	}

	/// Removes the current view controller from the parent view controller
	func remove() {
		self.removeFromParentViewController()
		self.view.removeFromSuperview()
	}
}

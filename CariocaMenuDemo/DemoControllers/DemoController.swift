import UIKit

protocol DemoController: class {
	func add(in parentViewController: UIViewController)
	func remove()
	var menuController: CariocaController? { get set }
}

extension DemoController where Self: UIViewController {

	func add(in parentViewController: UIViewController) {
		parentViewController.addChild(self)
		self.view.backgroundColor = .clear
		self.view.fill(in: parentViewController.view)
		parentViewController.view.layoutIfNeeded()
		setNeedsStatusBarAppearanceUpdate()
	}

	/// Removes the current view controller from the parent view controller
	func remove() {
		self.removeFromParent()
		self.view.removeFromSuperview()
	}
}

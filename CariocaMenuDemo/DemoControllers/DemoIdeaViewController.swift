import UIKit

class DemoIdeaViewController: UIViewController, DemoController {

	var menuController: CariocaController?

	var gradientColors: [(start: UIColor, end: UIColor)] = []

	override func viewWillAppear(_ animated: Bool) {
		self.view.addCariocaGestureHelpers([.left, .right])
	}
}

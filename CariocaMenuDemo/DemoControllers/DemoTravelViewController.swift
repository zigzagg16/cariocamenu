import UIKit

class DemoTravelViewController: UIViewController, DemoController {

	var menuController: CariocaController?

	override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

	override func viewWillAppear(_ animated: Bool) {
		self.view.addCariocaGestureHelpers([.left, .right], width: 30.0)
	}
}

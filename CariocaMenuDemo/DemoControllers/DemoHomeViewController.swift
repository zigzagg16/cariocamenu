import UIKit

class DemoHomeViewController: UIViewController, DemoController {

	var menuController: CariocaController?

	var gradientColors: [(start: UIColor, end: UIColor)] = [
		//amethyst, wisteria
		(start: UIColor(red: 0.60, green: 0.36, blue: 0.71, alpha: 1.00),
		 end: UIColor(red: 0.55, green: 0.29, blue: 0.67, alpha: 1.00)),
		//sunflower, orange
		(start: UIColor(red: 0.95, green: 0.61, blue: 0.17, alpha: 1.00),
		 end: UIColor(red: 0.95, green: 0.61, blue: 0.17, alpha: 1.00))
	]
}

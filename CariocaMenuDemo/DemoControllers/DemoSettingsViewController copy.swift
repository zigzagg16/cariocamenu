import UIKit

class DemoSettingsViewController: UIViewController, DemoController {

	var menuController: CariocaController?
	@IBOutlet weak var offScreenSwitch: UISwitch!
	@IBOutlet weak var boomerangType: UISegmentedControl!

	var gradientColors: [(start: UIColor, end: UIColor)] = [
		//turquoise, green sear
		(start: UIColor(red: 0.17, green: 0.73, blue: 0.61, alpha: 1.00),
		 end: UIColor(red: 0.14, green: 0.62, blue: 0.52, alpha: 1.00)),
		//emerald, nephritis
		(start: UIColor(red: 0.23, green: 0.79, blue: 0.45, alpha: 1.00),
		 end: UIColor(red: 0.20, green: 0.67, blue: 0.39, alpha: 1.00))
	]

	override func viewWillAppear(_ animated: Bool) {
		boomerangType.selectedSegmentIndex = menuController?.boomerang.rawValue ?? 0
		offScreenSwitch.isOn = (menuController?.isOffscreenAllowed)! ? true : false
	}

	@IBAction func didChangeBoomerangType(_ sender: UISegmentedControl) {
		menuController?.boomerang = BoomerangType(rawValue: sender.selectedSegmentIndex) ?? .none
	}

	@IBAction func didChangeOffScreen(_ sender: UISwitch) {
		menuController?.isOffscreenAllowed = sender.isOn ? true : false
	}
}

import UIKit

class DemoSettingsViewController: UIViewController, DemoController {
    weak var menuController: CariocaController?
    @IBOutlet weak var offScreenSwitch: UISwitch!
    @IBOutlet weak var boomerangType: UISegmentedControl!

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewWillAppear(_: Bool) {
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

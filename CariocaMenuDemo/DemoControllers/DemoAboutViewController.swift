import UIKit

class DemoAboutViewController: UIViewController, DemoController {

	weak var menuController: CariocaController?

	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

	@IBAction func actionTwitter(_ sender: UIButton) {
		openURL("http://bit.ly/2CWvb89")
	}

	@IBAction func actionGithub(_ sender: UIButton) {
		openURL("http://bit.ly/2AVql9B")
	}

	func openURL(_ urlString: String) {
		guard let url = URL(string: urlString) else { print("Could not open \(urlString)");return }
        UIApplication.shared.open(url, options: convert([:]), completionHandler: nil)
	}
}

// Helper function inserted by Swift 4.2 migrator.
private func convert(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in
        (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)
    })
}

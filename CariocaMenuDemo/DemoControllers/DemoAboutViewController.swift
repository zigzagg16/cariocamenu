import UIKit

class DemoAboutViewController: UIViewController, DemoController {

	var menuController: CariocaController?

	var gradientColors: [(start: UIColor, end: UIColor)] = []

	@IBAction func actionTwitter(_ sender: UIButton) {
		url("https://twitter.com/mmommommomo")
	}

	@IBAction func actionGithub(_ sender: UIButton) {
		url("https://github.com/arn00s/")
	}

	func url(_ urlString: String) {
		guard let url = URL(string: urlString) else { print("Could not open \(urlString)");return }
		UIApplication.shared.openURL(url)
	}
}

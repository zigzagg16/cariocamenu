import UIKit

class DemoIdeaViewController: UIViewController, DemoController, UIWebViewDelegate {
	@IBOutlet weak var webview: UIWebView!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	@IBOutlet weak var errorMessage: UILabel!
	@IBOutlet weak var tryAgain: UIButton!

	var menuController: CariocaController?

	var gradientColors: [(start: UIColor, end: UIColor)] = []

	override func viewWillAppear(_ animated: Bool) {
		self.view.addCariocaGestureHelpers([.left, .right])
	}

	override func viewDidLoad() {
		webview.delegate = self
		loader.hidesWhenStopped = true
		loader.stopAnimating()
	}
	override func viewDidAppear(_ animated: Bool) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
			self.loadURL()
		})
	}
	func loadURL() {
		guard let url = URL(string: "https://medium.com/search?q=Hamburger%20menu") else { return }
		webview.scrollView.isScrollEnabled = false
		errorMessage.isHidden = true
		tryAgain.isHidden = true
		webview.loadRequest(URLRequest(url: url))
	}
	func webViewDidStartLoad(_ webView: UIWebView) {
		loader.startAnimating()
	}
	func webViewDidFinishLoad(_ webView: UIWebView) {
		webview.scrollView.isScrollEnabled = true
		loader.stopAnimating()
	}
	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		webview.scrollView.isScrollEnabled = false
		loader.stopAnimating()
		webview.isHidden = true
		errorMessage.isHidden = false
		tryAgain.isHidden = false
	}
	@IBAction func tryAgainAction(_ sender: AnyObject) {
		loadURL()
	}
}

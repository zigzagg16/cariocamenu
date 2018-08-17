import UIKit
import WebKit

class DemoIdeaViewController: UIViewController, DemoController, UIWebViewDelegate {
	@IBOutlet weak var webview: WKWebView!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	@IBOutlet weak var errorMessage: UILabel!
	@IBOutlet weak var tryAgain: UIButton!

	weak var menuController: CariocaController?

	override func viewWillAppear(_ animated: Bool) {
		self.view.addCariocaGestureHelpers([.left, .right])
	}

	override func viewDidLoad() {
		loader.hidesWhenStopped = true
		loader.stopAnimating()
	}
	override func viewDidAppear(_ animated: Bool) {
		self.loadURL()
	}
	func loadURL() {
		guard let url = URL(string: "https://medium.com/search?q=Hamburger%20menu") else { return }
		errorMessage.isHidden = true
		tryAgain.isHidden = true
        webview.load(URLRequest(url: url))
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
    override func viewDidDisappear(_ animated: Bool) {
        cleanWebView()
        menuController = nil
    }
    private func cleanWebView() {
        webview.loadHTMLString("", baseURL: nil)
        webview.stopLoading()
        webview.removeFromSuperview()
        webview = nil
    }

	override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    override func didReceiveMemoryWarning() {
        cleanWebView()
    }
}

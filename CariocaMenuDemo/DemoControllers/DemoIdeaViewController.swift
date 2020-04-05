import UIKit
import WebKit

class DemoIdeaViewController: UIViewController, DemoController, UIWebViewDelegate {
    @IBOutlet var webview: WKWebView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var tryAgain: UIButton!

    weak var menuController: CariocaController?

    override func viewWillAppear(_: Bool) {
        view.addCariocaGestureHelpers([.left, .right])
    }

    override func viewDidLoad() {
        loader.hidesWhenStopped = true
        loader.stopAnimating()
    }

    override func viewDidAppear(_: Bool) {
        loadURL()
    }

    func loadURL() {
        guard let url = URL(string: "https://medium.com/search?q=Hamburger%20menu") else { return }
        errorMessage.isHidden = true
        tryAgain.isHidden = true
        webview.load(URLRequest(url: url))
    }

    func webViewDidStartLoad(_: UIWebView) {
        loader.startAnimating()
    }

    func webViewDidFinishLoad(_: UIWebView) {
        webview.scrollView.isScrollEnabled = true
        loader.stopAnimating()
    }

    func webView(_: UIWebView, didFailLoadWithError _: Error) {
        webview.scrollView.isScrollEnabled = false
        loader.stopAnimating()
        webview.isHidden = true
        errorMessage.isHidden = false
        tryAgain.isHidden = false
    }

    @IBAction func tryAgainAction(_: AnyObject) {
        loadURL()
    }

    override func viewDidDisappear(_: Bool) {
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

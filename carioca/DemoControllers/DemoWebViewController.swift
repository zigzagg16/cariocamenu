import UIKit

class DemoWebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var tryAgain: UIButton!

    override func viewDidLoad() {
        webview.delegate = self
        loader.hidesWhenStopped = true
    }
    override func viewDidAppear(_ animated: Bool) {
        loadURL()
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
        loader.isHidden = false
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webview.scrollView.isScrollEnabled = true
        loader.stopAnimating()
        loader.isHidden = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webview.scrollView.isScrollEnabled = false
        loader.stopAnimating()
        loader.isHidden = true
        webview.isHidden = true
        errorMessage.isHidden = false
        tryAgain.isHidden = false
    }
    @IBAction func tryAgainAction(_ sender: AnyObject) {
        loadURL()
    }
}

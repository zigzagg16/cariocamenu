
import UIKit

class DemoWebViewController: UIViewController, UIWebViewDelegate{
    
   
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var tryAgain: UIButton!
    
    
    override func viewDidLoad() {
        webview.delegate = self
        loader.hidesWhenStopped = true
    }
    
    override func viewDidAppear(animated: Bool) {
        loadURL()
    }
    
    func loadURL(){
        webview.scrollView.scrollEnabled = false
        errorMessage.hidden = true
        tryAgain.hidden = true
        webview.loadRequest(NSURLRequest(URL: NSURL(string: "https://medium.com/search?q=Hamburger%20menu")!))
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        loader.startAnimating()
        loader.hidden = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        webview.scrollView.scrollEnabled = true
        loader.stopAnimating()
        loader.hidden = true
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        webview.scrollView.scrollEnabled = false
        loader.stopAnimating()
        loader.hidden = true
        webview.hidden = true
        errorMessage.hidden = false
        tryAgain.hidden = false
    }
    @IBAction func tryAgainAction(sender: AnyObject) {
        loadURL()
    }
}
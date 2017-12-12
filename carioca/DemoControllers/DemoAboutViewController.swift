
import UIKit

class DemoAboutViewController: UIViewController{

    @IBAction func actionTwitter(sender: AnyObject) {
        url("https://twitter.com/arnaud_momo")
    }
    @IBAction func actionLinkedin(sender: AnyObject) {
        url("https://lu.linkedin.com/in/arnaudschloune")
    }
    @IBAction func actionGithub(sender: AnyObject) {
        url("https://github.com/arn00s/cariocamenu")
    }
    
    func url(urlString:String){
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
}
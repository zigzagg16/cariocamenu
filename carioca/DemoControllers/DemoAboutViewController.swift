
import UIKit

class DemoAboutViewController: UIViewController{

    @IBAction func actionTwitter(_ sender: AnyObject) {
        url("https://twitter.com/arnaud_momo")
    }
    @IBAction func actionLinkedin(_ sender: AnyObject) {
        url("https://lu.linkedin.com/in/arnaudschloune")
    }
    @IBAction func actionGithub(_ sender: AnyObject) {
        url("https://github.com/arn00s/cariocamenu")
    }
    
    func url(_ urlString:String){
        UIApplication.shared.openURL(URL(string: urlString)!)
    }
}

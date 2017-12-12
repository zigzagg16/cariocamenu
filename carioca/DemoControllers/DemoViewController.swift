
import UIKit

class DemoViewController: UIViewController, CariocaMenuDelegate {
    
    var menu:CariocaMenu?
    var logging = false
    var demoContentController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        //Initialise the tableviewcontroller of the menu
        let menuCtrl = self.storyboard?.instantiateViewControllerWithIdentifier("MyMenu") as! MyMenuContentController
        
        //Set the tableviewcontroller for the shared carioca menu
        menu = CariocaMenu(dataSource: menuCtrl)
        menu?.selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        menu?.delegate = self
        menu?.boomerang = .None
        
        //reverse delegate for cell selection by tap :
        menuCtrl.cariocaMenu = menu
        
        //show the first demo controller
        showDemoControllerForIndex(0)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        menu?.addInView(self.view)
        menu?.isDraggableVertically = true
//        menu?.showIndicator(.RightEdge, position: .Bottom, offset: -50)
        menu?.showIndicator(.RightEdge, position: .Center, offset: 30)
//        menu?.showIndicator(.RightEdge, position: .Top, offset: 50)
//        menu?.showIndicator(.LeftEdge, position: .Top, offset: 50)
//        menu?.showIndicator(.LeftEdge, position: .Center, offset: 50)
        
        menu?.addGestureHelperViews([.LeftEdge,.RightEdge], width:30)
    }
    
// MARK: - Various demo controllers
    
    func showDemoControllerForIndex(index:Int){
        
        if demoContentController != nil {
            demoContentController.view.removeFromSuperview()
            demoContentController.removeFromParentViewController()
            demoContentController = nil
        }
        
        switch index {
        
        case 1:
            if let demoWeb = self.storyboard?.instantiateViewControllerWithIdentifier("DemoWebView") as? DemoWebViewController{
                self.addChildViewController(demoWeb)
                self.view.addSubview(demoWeb.view)
                demoContentController = demoWeb as UIViewController
            }
            break
        case 2:
            if let demoMap = self.storyboard?.instantiateViewControllerWithIdentifier("DemoMapView") as? DemoMapViewController{
                self.addChildViewController(demoMap)
                self.view.addSubview(demoMap.view)
                demoContentController = demoMap as UIViewController
            }
            break
        case 3:
            if let demoScreen = self.storyboard?.instantiateViewControllerWithIdentifier("DemoSettingsView") as? DemoSettingsViewController{
                demoScreen.menu = menu
                self.addChildViewController(demoScreen)
                self.view.addSubview(demoScreen.view)
                demoContentController = demoScreen as UITableViewController
            }
            break
        case 4:
            if let demoAbout = self.storyboard?.instantiateViewControllerWithIdentifier("DemoAboutView") as? DemoAboutViewController{
                self.addChildViewController(demoAbout)
                self.view.addSubview(demoAbout.view)
                demoContentController = demoAbout as UIViewController
            }
            break
        default:
            if let demoIntro = self.storyboard?.instantiateViewControllerWithIdentifier("DemoIntroView") as? DemoIntroViewController{
                self.addChildViewController(demoIntro)
                self.view.addSubview(demoIntro.view)
                demoContentController = demoIntro as UIViewController
            }
            break
        }
        
        demoContentController.view.translatesAutoresizingMaskIntoConstraints = false
        
        //Add constraints for autolayout
        self.view.addConstraints([
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .Trailing),
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .Leading),
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .Bottom),
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .Top)
            ])
        
        self.view.setNeedsLayout()
        
        menu?.moveToTop()
    }
    
    
    private func getEqualConstraint(item: AnyObject, toItem: AnyObject, attribute: NSLayoutAttribute) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: 0)
    }
    
// MARK: - CariocaMenu Delegate
    
    ///`Optional` Called when a menu item was selected
    ///- parameters:
    ///  - menu: The menu object
    ///  - indexPath: The selected indexPath
    func cariocaMenuDidSelect(menu:CariocaMenu, indexPath:NSIndexPath) {
        
        showDemoControllerForIndex(indexPath.row)
    }
    
    ///`Optional` Called when the menu is about to open
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuWillOpen(menu:CariocaMenu) {
        if(logging){
            print("carioca MenuWillOpen \(menu)")
        }
    }
    
    ///`Optional` Called when the menu just opened
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuDidOpen(menu:CariocaMenu){
        if(logging){
            switch menu.openingEdge{
                case .LeftEdge:
                    print("carioca MenuDidOpen \(menu) left")
                break;
                default:
                    print("carioca MenuDidOpen \(menu) right")
                break;
            }
        }
    }
    
    ///`Optional` Called when the menu is about to be dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    func cariocaMenuWillClose(menu:CariocaMenu) {
        if(logging){
            print("carioca MenuWillClose \(menu)")
        }
    }
    
    ///`Optional` Called when the menu is dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    func cariocaMenuDidClose(menu:CariocaMenu){
        if(logging){
            print("carioca MenuDidClose \(menu)")
        }
    }
    
    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//Used in demo controllers, simply to round the button's corners

class roundedButton:UIButton{

    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
}


import UIKit

class DemoViewController: UIViewController, CariocaMenuDelegate {
    
    var menu:CariocaMenu?
    var logging = false
    var demoContentController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        //Initialise the tableviewcontroller of the menu
        let menuCtrl = self.storyboard?.instantiateViewController(withIdentifier: "MyMenu") as! MyMenuContentController
        
        //Set the tableviewcontroller for the shared carioca menu
        menu = CariocaMenu(dataSource: menuCtrl)
        menu?.selectedIndexPath = IndexPath(item: 0, section: 0)
        
        menu?.delegate = self
        menu?.boomerang = .none
        
        //reverse delegate for cell selection by tap :
        menuCtrl.cariocaMenu = menu
        
        //show the first demo controller
        showDemoControllerForIndex(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        menu?.addInView(self.view)
        menu?.isDraggableVertically = true
//        menu?.showIndicator(.RightEdge, position: .Bottom, offset: -50)
        menu?.showIndicator(.rightEdge, position: .center, offset: 30)
//        menu?.showIndicator(.RightEdge, position: .Top, offset: 50)
//        menu?.showIndicator(.LeftEdge, position: .Top, offset: 50)
//        menu?.showIndicator(.LeftEdge, position: .Center, offset: 50)
        
        menu?.addGestureHelperViews([.leftEdge,.rightEdge], width:30)
    }
    
// MARK: - Various demo controllers
    
    func showDemoControllerForIndex(_ index:Int){
        
        if demoContentController != nil {
            demoContentController.view.removeFromSuperview()
            demoContentController.removeFromParentViewController()
            demoContentController = nil
        }
        
        switch index {
        
        case 1:
            if let demoWeb = self.storyboard?.instantiateViewController(withIdentifier: "DemoWebView") as? DemoWebViewController{
                self.addChildViewController(demoWeb)
                self.view.addSubview(demoWeb.view)
                demoContentController = demoWeb as UIViewController
            }
            break
        case 2:
            if let demoMap = self.storyboard?.instantiateViewController(withIdentifier: "DemoMapView") as? DemoMapViewController{
                self.addChildViewController(demoMap)
                self.view.addSubview(demoMap.view)
                demoContentController = demoMap as UIViewController
            }
            break
        case 3:
            if let demoScreen = self.storyboard?.instantiateViewController(withIdentifier: "DemoSettingsView") as? DemoSettingsViewController{
                demoScreen.menu = menu
                self.addChildViewController(demoScreen)
                self.view.addSubview(demoScreen.view)
                demoContentController = demoScreen as UITableViewController
            }
            break
        case 4:
            if let demoAbout = self.storyboard?.instantiateViewController(withIdentifier: "DemoAboutView") as? DemoAboutViewController{
                self.addChildViewController(demoAbout)
                self.view.addSubview(demoAbout.view)
                demoContentController = demoAbout as UIViewController
            }
            break
        default:
            if let demoIntro = self.storyboard?.instantiateViewController(withIdentifier: "DemoIntroView") as? DemoIntroViewController{
                self.addChildViewController(demoIntro)
                self.view.addSubview(demoIntro.view)
                demoContentController = demoIntro as UIViewController
            }
            break
        }
        
        demoContentController.view.translatesAutoresizingMaskIntoConstraints = false
        
        //Add constraints for autolayout
        self.view.addConstraints([
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .trailing),
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .leading),
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .bottom),
            getEqualConstraint(demoContentController.view, toItem: self.view, attribute: .top)
            ])
        
        self.view.setNeedsLayout()
        
        menu?.moveToTop()
    }
    
    
    fileprivate func getEqualConstraint(_ item: AnyObject, toItem: AnyObject, attribute: NSLayoutAttribute) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: 0)
    }
    
// MARK: - CariocaMenu Delegate
    
    ///`Optional` Called when a menu item was selected
    ///- parameters:
    ///  - menu: The menu object
    ///  - indexPath: The selected indexPath
    func cariocaMenuDidSelect(_ menu:CariocaMenu, indexPath:IndexPath) {
        
        showDemoControllerForIndex((indexPath as NSIndexPath).row)
    }
    
    ///`Optional` Called when the menu is about to open
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuWillOpen(_ menu:CariocaMenu) {
        if(logging){
            print("carioca MenuWillOpen \(menu)")
        }
    }
    
    ///`Optional` Called when the menu just opened
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuDidOpen(_ menu:CariocaMenu){
        if(logging){
            switch menu.openingEdge{
                case .leftEdge:
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
    func cariocaMenuWillClose(_ menu:CariocaMenu) {
        if(logging){
            print("carioca MenuWillClose \(menu)")
        }
    }
    
    ///`Optional` Called when the menu is dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    func cariocaMenuDidClose(_ menu:CariocaMenu){
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

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
}

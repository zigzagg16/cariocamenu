import UIKit

class DemoViewController: UIViewController, CariocaMenuDelegate {
    var menu: CariocaMenu?
    var logging = false
    var demoContentController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidAppear(_ animated: Bool) {
        initialiseCariocaMenu()
    }

    private func initialiseCariocaMenu() {
        //Initialise the tableviewcontroller of the menu
        guard let menuCtrl = self.storyboard?.instantiateViewController(withIdentifier: "MyMenu")
            as? MyMenuContentController,
            menu == nil else { return }
        //Set the tableviewcontroller for the shared carioca menu
        menu = CariocaMenu(dataSource: menuCtrl,
                           delegate: self,
                           hostView: self.view)
        menu?.boomerang = .none
        //reverse delegate for cell selection by tap :
        menuCtrl.cariocaMenu = menu
        menu?.isDraggableVertically = true
        menu?.showIndicator(.right, position: .center, offset: 30)
        menu?.addGestureHelperViews([.left, .right], width: 30)
        //show the first demo controller
        showDemoControllerForIndex(0)
    }

// MARK: - Various demo controllers

    func showDemoControllerForIndex(_ index: Int) {
        if demoContentController != nil {
            demoContentController?.view.removeFromSuperview()
            demoContentController?.removeFromParentViewController()
            demoContentController = nil
        }
        self.childViewControllers.forEach { demo in
            demo.removeFromParentViewController()
        }
        switch index {
        case 1:
            demoContentController = demo(type: DemoWebViewController.self, identifier: "DemoWebView")
        case 2:
            demoContentController = demo(type: DemoMapViewController.self, identifier: "DemoMapView")
        case 3:
            if let demoScreen = self.storyboard?.instantiateViewController(withIdentifier: "DemoSettingsView")
                as? DemoSettingsViewController {
                demoScreen.menu = menu
                self.addChildViewController(demoScreen)
                self.view.addSubview(demoScreen.view)
                demoContentController = demoScreen as UITableViewController
            }
        case 4:
            demoContentController = demo(type: DemoAboutViewController.self, identifier: "DemoAboutView")
        default:
            demoContentController = demo(type: DemoIntroViewController.self, identifier: "DemoIntroView")
        }
        applyConstraints(view: demoContentController!.view)
        menu?.moveToTop()
    }

    func demo<T>(type: T.Type, identifier: String) -> T? {
        guard let demo = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? T,
            let demoController = demo as? UIViewController else { return nil }
        self.addChildViewController(demoController)
        self.view.addSubview(demoController.view)
        return demo
    }

    fileprivate func applyConstraints(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //Add constraints for autolayout
        self.view.addConstraints([
            getEqualConstraint(view, toItem: self.view, attribute: .trailing),
            getEqualConstraint(view, toItem: self.view, attribute: .leading),
            getEqualConstraint(view, toItem: self.view, attribute: .bottom),
            getEqualConstraint(view, toItem: self.view, attribute: .top)
            ])
        self.view.setNeedsLayout()
    }

    fileprivate func getEqualConstraint(_ item: AnyObject,
                                        toItem: AnyObject,
                                        attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item,
                                  attribute: attribute,
                                  relatedBy: .equal,
                                  toItem: toItem,
                                  attribute: attribute,
                                  multiplier: 1,
                                  constant: 0)
    }
// MARK: - CariocaMenu Delegate
    ///`Optional` Called when a menu item was selected
    ///- parameters:
    ///  - menu: The menu object
    ///  - indexPath: The selected indexPath
    func cariocaMenuDidSelect(_ menu: CariocaMenu, indexPath: IndexPath) {
        showDemoControllerForIndex(indexPath.row)
    }

    ///`Optional` Called when the menu is about to open
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuWillOpen(_ menu: CariocaMenu) {
        if logging {
            print("carioca MenuWillOpen \(menu)")
        }
    }
    ///`Optional` Called when the menu just opened
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuDidOpen(_ menu: CariocaMenu) {
        if logging {
            switch menu.openingEdge {
            case .left :
                print("carioca MenuDidOpen \(menu) left")
            default :
                print("carioca MenuDidOpen \(menu) right")
            }
        }
    }

    ///`Optional` Called when the menu is about to be dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    func cariocaMenuWillClose(_ menu: CariocaMenu) {
        if logging {
            print("carioca MenuWillClose \(menu)")
        }
    }

    ///`Optional` Called when the menu is dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    func cariocaMenuDidClose(_ menu: CariocaMenu) {
        if logging {
            print("carioca MenuDidClose \(menu)")
        }
    }

    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//Used in demo controllers, simply to round the button's corners

class RoundedButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
}

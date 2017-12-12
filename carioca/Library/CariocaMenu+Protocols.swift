import Foundation
import UIKit
// MARK: Delegate Protocol
///Delegate Protocol for events on menu opening/closing
@objc public protocol CariocaMenuDelegate {
    ///`Optional` Called when the menu is about to open
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuWillOpen(_ menu: CariocaMenu)
    ///`Optional` Called when the menu just opened
    ///- parameters:
    ///  - menu: The opening menu object
    func cariocaMenuDidOpen(_ menu: CariocaMenu)
    ///`Optional` Called when the menu is about to be dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    func cariocaMenuWillClose(_ menu: CariocaMenu)
    ///`Optional` Called when the menu is dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    func cariocaMenuDidClose(_ menu: CariocaMenu)
    ///`Optional` Called when a menu item was selected
    ///- parameters:
    ///  - menu: The menu object
    ///  - indexPath: The selected indexPath
    func cariocaMenuDidSelect(_ menu: CariocaMenu, indexPath: IndexPath)
}

// MARK: - Datasource Protocol
///DataSource protocol for filling up the menu
@objc public protocol CariocaMenuDataSource {
    ///The view of the menu that will be displayed
    var menuView: UIView { get }
    ///`Optional` for pin Shape color overrides
    ///- returns: 'UIColor' of open menu item.
    var shapeColor: UIColor? { get set }
    ///Menu BG BlurStyle overrides
    ///- returns: 'UIBlurEffectStyle' of menu's BG.
    var blurStyle: UIBlurEffectStyle { get set }
    ///`Optional` Unselects a menu item
    ///- parameters:
    ///  - indexPath: The required indexPath
    func unselectRowAtIndexPath(_ indexPath: IndexPath)
    ///`Optional` Will be called when the indicator hovers a menu item.
    ///You may apply some custom styles to your UITableViewCell
    ///- parameters:
    ///  - indexPath: The preselected indexPath
    func preselectRowAtIndexPath(_ indexPath: IndexPath)
    ///`Required` Will be called when the user selects a menu item (by tapping or just releasing the indicator)
    ///- parameters:
    ///  - indexPath: The selected indexPath
    func selectRowAtIndexPath(_ indexPath: IndexPath)
    ///`Required` Gets the height by each row of the menu. Used for internal calculations
    ///- returns: `CGFloat` The height for each menu item.
    ///- warning: The height should be the same for each row
    ///- todo: Manage different heights for each row
    func heightByMenuItem() -> CGFloat
    ///`Required` Gets the number of menu items
    ///- returns: `Int` The total number of menu items
    func numberOfMenuItems() -> Int
    ///`Required` Gets the icon for a specific menu item
    ///- parameters:
    ///  - indexPath: The required indexPath
    ///- returns: `UIImage` The image to show in the indicator. Should be the same that the image displayed in the menu.
    ///- todo: Add emoji support ?👍
    func iconForRowAtIndexPath(_ indexPath: IndexPath) -> UIImage
    ///`Optional` Sets the selected indexPath
    ///- parameters:
    ///  - indexPath: The selected indexPath
    func setSelectedIndexPath(_ indexPath: IndexPath)
    ///`Optional` Sets the cell identifier.
    ///Used to adapt the tableView cells depending on which side the menu is presented.
    ///- parameters:
    ///  - identifier: The cell identifier
    func setCellIdentifierForEdge(_ identifier: String)
}


import UIKit

class MyMenuContentController: UITableViewController, CariocaMenuDataSource {
    
    var iconNames = Array<String>()
    var menuNames = Array<String>()
    weak var cariocaMenu:CariocaMenu?
    var cellTypeIdentifier = "cellLeft"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.scrollsToTop = false
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        iconNames.append("hello")
        iconNames.append("hamburger")
        iconNames.append("map")
        iconNames.append("settings")
        iconNames.append("about")
        
        menuNames.append("Hello")
        menuNames.append("Hamburger")
        menuNames.append("Travel")
        menuNames.append("Settings")
        menuNames.append("About")
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTypeIdentifier, forIndexPath: indexPath) as! MyMenuTableViewCell
        //set the title in the cell
        cell.titleLabel.text = menuNames[indexPath.row]
        
        if (indexPath == cariocaMenu?.selectedIndexPath){
//            CariocaMenu.Log("cellForRow : selected")
            cell.applyStyleSelected()
        }
        else{
//            CariocaMenu.Log("cellForRow : normal")
            cell.applyStyleNormal()
        }
        
        cell.iconImageView.image = UIImage(named: "\(iconNames[indexPath.row])_menu.png")!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0))
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    
//MARK: - Cell styles and selection/preselection
    
    func unselectRowAtIndexPath(indexPath: NSIndexPath) -> Void {
//        CariocaMenu.Log("unselectRowAtIndexPath \(indexPath.row)")
        if (indexPath == cariocaMenu?.selectedIndexPath){
            getCellFor(indexPath).applyStyleSelected()
        }else {
            getCellFor(indexPath).applyStyleNormal()
        }
    }
    
    func preselectRowAtIndexPath(indexPath: NSIndexPath) -> Void {
//        CariocaMenu.Log("preselectRowAtIndexPath \(indexPath.row)")
        getCellFor(indexPath).applyStyleHighlighted()
    }
    
    func setSelectedIndexPath(indexPath: NSIndexPath) -> Void {
//        CariocaMenu.Log("setSelectedIndexPath \(indexPath.row)")
        getCellFor(indexPath).applyStyleSelected()
    }
    
    //Called when the user releases the gesture on a menu item
    func selectRowAtIndexPath(indexPath: NSIndexPath) -> Void {
//        CariocaMenu.Log("selectRowAtIndexPath \(indexPath.row)")
        self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath)
    }
    
// MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        CariocaMenu.Log("didSelectRowAtIndexPath \(indexPath.row)")
        //Transfer the event to the menu, so that he can manage the selection
        cariocaMenu?.didSelectRowAtIndexPath(indexPath, fromContentController:true)
    }
    
    // MARK: - Get the Cell
    
    private func getCellFor(indexPath:NSIndexPath)->MyMenuTableViewCell {
        return self.tableView.cellForRowAtIndexPath(indexPath) as! MyMenuTableViewCell
    }
    
    // MARK: - Data source protocol
    
    func getMenuView()->UIView{        
        return self.view
    }
    
    func heightByMenuItem()->CGFloat {
        return self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
    }
    
    func numberOfMenuItems()->Int {
        return self.tableView(self.tableView, numberOfRowsInSection: 0)
    }
    
    func iconForRowAtIndexPath(indexPath:NSIndexPath)->UIImage {
        return UIImage(named: "\(iconNames[indexPath.row])_indicator.png")!
    }
    
    func setCellIdentifierForEdge(identifier:String)->Void {
        cellTypeIdentifier = identifier
        self.tableView.reloadData()
    }
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

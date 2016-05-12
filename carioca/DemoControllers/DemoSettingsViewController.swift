
import UIKit

class DemoSettingsViewController: UITableViewController{
    
    weak var menu:CariocaMenu?
    
    var settingsNames = Array<String>()
    
    override func viewDidLoad() {
        settingsNames.append("Screen edges")
        settingsNames.append("Dragging")
        settingsNames.append("Boomerang")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellTypeIdentifier = indexPath.row == 2 ? "cellSegment" : "cellSwitch"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTypeIdentifier, forIndexPath: indexPath)
        
        //set the title in the cell
        let title = cell.viewWithTag(10) as! UILabel
        title.text = settingsNames[indexPath.row]
        
        let description = cell.viewWithTag(20) as! UITextView
        var descriptionText = ""
        
        switch indexPath.row {
        
            //edges
        case 0:
            let switcher = cell.viewWithTag(30) as! UISwitch
            switcher.addTarget(self, action: #selector(DemoSettingsViewController.edgesSwitchChanged(_:)), forControlEvents: .ValueChanged)
            switcher.setOn((menu?.isAlwaysOnScreen)!, animated: true)
            descriptionText = (menu?.isAlwaysOnScreen)! ? "The menu stays on screen." : "The menu is completely free !!"
            
            break
            
            //dragging
        case 1:
            let switcher = cell.viewWithTag(30) as! UISwitch
            switcher.addTarget(self, action: #selector(DemoSettingsViewController.dragSwitchChanged(_:)), forControlEvents: .ValueChanged)
            switcher.setOn((menu?.isDraggableVertically)!, animated: true)
            descriptionText = (menu?.isDraggableVertically)! ? "The user can drag the indicators." : "No dragging of the indicators."
            
            break

            //boomerang
        default:
            let segment = cell.viewWithTag(30) as! UISegmentedControl
            segment.addTarget(self, action: #selector(DemoSettingsViewController.boomerangSegmentChanged(_:)), forControlEvents: .ValueChanged)
            
            if menu?.boomerang == .Vertical {
                segment.selectedSegmentIndex = 1
                descriptionText = "The menu always comes back at it's initial Y position."
            }
            else if menu?.boomerang == .VerticalAndHorizontal {
                segment.selectedSegmentIndex = 2
                descriptionText = "The menu always comes back in place 👍"
            }
            else {
                segment.selectedSegmentIndex = 0
                descriptionText = "By default, there is no boomerang set to the menu."
            }
            
            break
        }
        
        description.text = descriptionText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 2 ? 140 : 90.0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0))
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 80))
        view.backgroundColor = UIColor.clearColor()
        return view
    }

    func boomerangSegmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            menu?.boomerang = .Vertical
            break;
        case 2:
            menu?.boomerang = .VerticalAndHorizontal
        default:
            menu?.boomerang = .None
            break;
        }
        
        self.tableView.reloadData()
    }
    
    func edgesSwitchChanged(sender: UISwitch) {
        menu?.isAlwaysOnScreen = (menu?.isAlwaysOnScreen == true) ? false : true
        self.tableView.reloadData()
    }
    
    func dragSwitchChanged(sender: UISwitch) {
        menu?.isDraggableVertically = (menu?.isDraggableVertically == true) ? false : true
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        menu = nil
    }
}
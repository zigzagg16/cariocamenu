import UIKit

class DemoSettingsViewController: UITableViewController {
    weak var menu: CariocaMenu?
    var settingsNames = [String]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        settingsNames = ["Screen edges",
                         "Dragging",
                         "Boomerang"]
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellTypeIdentifier = indexPath.row == 2 ? "cellSegment" : "cellSwitch"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTypeIdentifier, for: indexPath)

        //set the title in the cell
        // swiftlint:disable force_cast
        let title = cell.viewWithTag(10) as! UILabel
        let description = cell.viewWithTag(20) as! UITextView
        // swiftlint:enable force_cast
        title.text = settingsNames[indexPath.row]
        var descriptionText = ""

        switch indexPath.row {
        case 0: //edges
            // swiftlint:disable force_cast
            let switcher = cell.viewWithTag(30) as! UISwitch
            // swiftlint:enable force_cast
            switcher.addTarget(self,
                               action: #selector(DemoSettingsViewController.edgesSwitchChanged(_:)),
                               for: .valueChanged)
            switcher.setOn((menu?.isAlwaysOnScreen)!, animated: true)
            descriptionText = (menu?.isAlwaysOnScreen)! ? "The menu stays on screen." : "The menu is completely free !!"
        case 1: //dragging
            // swiftlint:disable force_cast
            let switcher = cell.viewWithTag(30) as! UISwitch
            // swiftlint:enable force_cast
            switcher.addTarget(self,
                               action: #selector(DemoSettingsViewController.dragSwitchChanged(_:)),
                               for: .valueChanged)
            switcher.setOn((menu?.isDraggableVertically)!, animated: true)
            descriptionText = (menu?.isDraggableVertically)! ?
                "The user can drag the indicators." : "No dragging of the indicators."
        default: //boomerang
            // swiftlint:disable force_cast
            let segment = cell.viewWithTag(30) as! UISegmentedControl
            // swiftlint:enable force_cast
            segment.addTarget(self,
                              action: #selector(DemoSettingsViewController.boomerangSegmentChanged(_:)),
                              for: .valueChanged)

            if menu?.boomerang == .vertical {
                segment.selectedSegmentIndex = 1
                descriptionText = "The menu always comes back at it's initial Y position."
            } else if menu?.boomerang == .verticalAndHorizontal {
                segment.selectedSegmentIndex = 2
                descriptionText = "The menu always comes back in place 👍"
            } else {
                segment.selectedSegmentIndex = 0
                descriptionText = "By default, there is no boomerang set to the menu."
            }
        }
        description.text = descriptionText
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 2 ? 140 : 90.0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
        view.backgroundColor = UIColor.clear
        return view
    }

    func boomerangSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            menu?.boomerang = .vertical
        case 2:
            menu?.boomerang = .verticalAndHorizontal
        default:
            menu?.boomerang = .none
        }
        self.tableView.reloadData()
    }

    func edgesSwitchChanged(_ sender: UISwitch) {
        menu?.isAlwaysOnScreen = (menu?.isAlwaysOnScreen == true) ? false : true
        self.tableView.reloadData()
    }

    func dragSwitchChanged(_ sender: UISwitch) {
        menu?.isDraggableVertically = (menu?.isDraggableVertically == true) ? false : true
        self.tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        menu = nil
    }
}

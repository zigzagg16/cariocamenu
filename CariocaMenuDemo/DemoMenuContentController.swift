import UIKit

class DemoMenuContentController: UITableViewController {

    var menuNames:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        menuNames = ["Hello", "Settings", "About"]
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //set the title in the cell
        cell.textLabel?.text = menuNames[indexPath.row]
        //let image = UIImage(named: "\(menuNames[indexPath.row].lowercased())_menu.png")!
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
    }
}

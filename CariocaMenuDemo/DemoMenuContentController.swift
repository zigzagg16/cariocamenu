import UIKit

class DemoMenuContentController: UITableViewController, CariocaDataSource {

    var menuNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        menuNames = ["Hello", "Settings", "About"]
        tableView.reloadData()
    }

    // MARK: - Table view data source
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

    func heightForRow() -> CGFloat {
        return 60.0
    }
}

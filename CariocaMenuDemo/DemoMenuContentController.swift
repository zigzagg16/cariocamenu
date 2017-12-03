import UIKit

class DemoMenuContentController: UITableViewController, CariocaDataSource {

    var menuItems: [CariocaMenuItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = [
			CariocaMenuItem("😍", "😍"),
			CariocaMenuItem("🤙🏼", "🤙🏼"),
			CariocaMenuItem("🛠", "🛠"),
			CariocaMenuItem("🔮", "🔮"),
			CariocaMenuItem("🇧🇷", "🇧🇷")
		]
        tableView.reloadData()
    }

    // MARK: - menu data source
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withEdge edge: UIRectEdge) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = menuItems[indexPath.row].title
		//let image = UIImage(named: "\(menuNames[indexPath.row].lowercased())_menu.png")!
		return cell
	}

    func heightForRow() -> CGFloat {
        return 60.0
    }
}

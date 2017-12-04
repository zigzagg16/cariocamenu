import UIKit

class DemoMenuContentController: UITableViewController, CariocaDataSource {

	var menuItems: [CariocaMenuItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}

    // MARK: - menu data source
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath,
				   withEdge edge: UIRectEdge) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
	}

    func heightForRow() -> CGFloat {
        return 60.0
    }
}

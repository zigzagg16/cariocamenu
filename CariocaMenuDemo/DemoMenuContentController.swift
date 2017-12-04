import UIKit

class DemoMenuContentController: UITableViewController, CariocaDataSource {

	var menuItems: [CariocaMenuItem] = []

    // MARK: - menu data source
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath,
				   withEdge edge: UIRectEdge) -> UITableViewCell {
		let menuItem = menuItems[indexPath.row]
		//swiftlint:disable force_cast
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemCell
		//swiftlint:enable force_cast
		cell.titleLabel.text = menuItem.title
		cell.titleLabel.textAlignment = (edge == .left) ? .right : .left
		return cell
	}

    func heightForRow() -> CGFloat {
        return 60.0
    }
}

class MenuItemCell: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
}

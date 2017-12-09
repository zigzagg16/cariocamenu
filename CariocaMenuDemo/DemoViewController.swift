//
//  ViewController.swift
//  CariocaMenuDemo
//

import UIKit

class DemoViewController: UIViewController {
    var carioca: CariocaMenu?
	@IBOutlet weak var iconView: CariocaIconView!

    override func viewDidAppear(_ animated: Bool) {
		iconView.display(icon: CariocaIcon.emoji("🤙🏼"))
        initialiseCarioca()
    }

    func initialiseCarioca() {
        if var menuController = self.storyboard?.instantiateViewController(withIdentifier: "DemoMenu")
            as? CariocaController {
			addChildViewController(menuController)
			menuController.menuItems = [
				CariocaMenuItem("Hello", .emoji("🤙🏼")),
				CariocaMenuItem("About", .icon(UIImage(named: "hamburger")!)),
				CariocaMenuItem("Settings", .emoji("🛠")),
				CariocaMenuItem("Hamburger menu", .emoji("🔮")),
				CariocaMenuItem("Brasil", .emoji("🇧🇷"))
			]
			carioca = CariocaMenu(controller: menuController,
								  hostView: self.view,
								  edges: [.right, .left],
//								  edges: [.left, .right],
//								  edges: [.left],
								  delegate: self)
			carioca?.addInHostView()
        }
    }
}

extension DemoViewController: CariocaDelegate {
	func cariocamenu(_ menu: CariocaMenu, didSelect item: CariocaMenuItem, at index: Int) {
        CariocaMenu.log("didSelect \(item) at \(index)")
		iconView.display(icon: item.icon)
    }

    func cariocamenu(_ menu: CariocaMenu, willOpenFromEdge edge: UIRectEdge) {
        CariocaMenu.log("will open from \(edge)")
    }
}

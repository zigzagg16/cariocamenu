//
//  ViewController.swift
//  CariocaMenuDemo
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    var carioca: CariocaMenu?
	@IBOutlet weak var selectedLabel: UILabel!
	@IBOutlet weak var iconView: CariocaIconView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
		iconView.display(icon: CariocaIcon.emoji("🤙🏼"))
        initialiseCarioca()
    }

    func initialiseCarioca() {
        if var menuController = self.storyboard?.instantiateViewController(withIdentifier: "DemoMenu")
            as? CariocaController {
			menuController.menuItems = [
				CariocaMenuItem("Hello", .icon(UIImage(named: "hamburger")!)),
				CariocaMenuItem("About", .emoji("🤙🏼")),
				CariocaMenuItem("Settings", .emoji("🛠")),
				CariocaMenuItem("Hamburger menu", .emoji("🔮")),
				CariocaMenuItem("Brasil", .emoji("🇧🇷"))
			]
            carioca = CariocaMenu(controller: menuController,
                                  hostView: self.view,
                                  edges: [.left, .right],
                                  delegate: self)
            carioca?.addInHostView()
			self.addChildViewController(menuController)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DemoViewController: CariocaDelegate {
	func cariocamenu(_ menu: CariocaMenu, didSelect item: CariocaMenuItem, at index: Int) {
        CariocaMenu.log("\(menu) didSelect \(item) at \(index)")
		iconView.display(icon: item.icon)
    }

    func cariocamenu(_ menu: CariocaMenu, willOpenFromEdge edge: UIRectEdge) {
        CariocaMenu.log("\(menu) will open from \(edge)")
    }
}

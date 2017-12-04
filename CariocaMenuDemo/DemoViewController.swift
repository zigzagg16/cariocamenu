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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        initialiseCarioca()
    }

    func initialiseCarioca() {
        if var menuController = self.storyboard?.instantiateViewController(withIdentifier: "DemoMenu")
            as? CariocaController {
			menuController.menuItems = [
				CariocaMenuItem("😍", "😍"),
				CariocaMenuItem("🤙🏼", "🤙🏼"),
				CariocaMenuItem("🛠", "🛠"),
				CariocaMenuItem("🔮", "🔮"),
				CariocaMenuItem("🇧🇷", "🇧🇷")
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
    func cariocamenu(_ menu: CariocaMenu, didSelectItemAt index: Int) {
        CariocaMenu.log("\(menu) didSelectItemAt \(index)")
    }

    func cariocamenu(_ menu: CariocaMenu, willOpenFromEdge edge: UIRectEdge) {
        CariocaMenu.log("\(menu) will open from \(edge)")
    }
}

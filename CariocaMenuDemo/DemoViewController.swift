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
								  delegate: self,
								  indicator: CariocaCustomIndicatorView()
								  )
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

class CariocaCustomIndicatorView: UIView, CariocaIndicatorConfiguration {
	public var size: CGSize = CGSize(width: 47, height: 40)
	public var borderMargin: CGFloat = 5.0
	public var color: UIColor = UIColor(red: 0.07, green: 0.73, blue: 0.86, alpha: 1)
	public var bouncingValues: BouncingValues = (from: 15.0, to: 5.0)
	public func bezierPath(for edge: UIRectEdge) -> UIBezierPath {
		return UIBezierPath()
	}
}

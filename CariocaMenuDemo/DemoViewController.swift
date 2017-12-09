//
//  ViewController.swift
//  CariocaMenuDemo
//

import UIKit

class DemoViewController: UIViewController {
    var carioca: CariocaMenu?
	@IBOutlet weak var iconView: CariocaIconView!

    override func viewDidAppear(_ animated: Bool) {
		iconView.label.font = UIFont.boldSystemFont(ofSize: 75)
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
				CariocaMenuItem("Brasil", .emoji("🇧🇷")),
				CariocaMenuItem("ZZZ", .emoji("Z"))
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
	// MARK: Rotation management
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animateAlongsideTransition(in: self.view, animation: nil, completion: { [weak self] _ in
			self?.carioca?.hostViewDidRotate()
		})
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
	public var color: UIColor = .orange
	public func iconMargins(for edge: UIRectEdge) -> (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
//		if edge == .left {
			return (top: 0.0, right: 0.0, bottom: 0.0, left: 0.0)
//		} else {}
	}
}

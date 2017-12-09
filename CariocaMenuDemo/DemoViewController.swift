//
//  ViewController.swift
//  CariocaMenuDemo
//

import UIKit

class DemoViewController: UIViewController {
    var carioca: CariocaMenu?
	@IBOutlet weak var iconView: CariocaIconView!
	@IBOutlet weak var gradientView: ASGradientView!

	override func viewDidLoad() {
		setupGradient()
	}

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
//								  indicator: CustomPolygonIndicator()
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
	// MARK: Gradient setup
	func setupGradient() {
		gradientView.colors = [
			//turquoise, green sear
			(start: UIColor(red: 0.17, green: 0.73, blue: 0.61, alpha: 1.00),
			 end: UIColor(red: 0.14, green: 0.62, blue: 0.52, alpha: 1.00)),
			//emerald, nephritis
			(start: UIColor(red: 0.23, green: 0.79, blue: 0.45, alpha: 1.00),
			 end: UIColor(red: 0.20, green: 0.67, blue: 0.39, alpha: 1.00)),
			//amethyst, wisteria
			(start: UIColor(red: 0.60, green: 0.36, blue: 0.71, alpha: 1.00),
			 end: UIColor(red: 0.55, green: 0.29, blue: 0.67, alpha: 1.00)),
			//sunflower, orange
			(start: UIColor(red: 0.95, green: 0.61, blue: 0.17, alpha: 1.00),
			 end: UIColor(red: 0.95, green: 0.61, blue: 0.17, alpha: 1.00))
		]

		gradientView.animateGradient()
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
	var color: UIColor = UIColor.black
}

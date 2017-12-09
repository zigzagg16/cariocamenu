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
	public var size: CGSize = CGSize(width: 50, height: 40)
	public var borderMargin: CGFloat = 5.0
	public var color: UIColor = UIColor(red: 0.07, green: 0.73, blue: 0.86, alpha: 1)
	public var bouncingValues: BouncingValues = (from: 15.0, to: 5.0)
	public var font: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
	public func shape(for edge: UIRectEdge, frame: CGRect) -> UIBezierPath {
		//This shape was drawed with PaintCode App
		let ovalPath = UIBezierPath()
		if edge == .left {
			ovalPath.move(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.minY),
							  controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.22 * frame.height),
							  controlPoint2: CGPoint(x: frame.maxX - 9, y: frame.minY))
			ovalPath.addCurve(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.maxX - 31, y: frame.minY),
							  controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 0.3 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.maxY),
							  controlPoint1: CGPoint(x: frame.minX, y: frame.minY + 0.7 * frame.height),
							  controlPoint2: CGPoint(x: frame.maxX - 31, y: frame.maxY))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.maxX - 9, y: frame.maxY),
							  controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.78 * frame.height))
		} else {
			//right
			ovalPath.move(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.minX + 20, y: frame.minY),
							  controlPoint1: CGPoint(x: frame.minX, y: frame.minY + 0.22 * frame.height),
							  controlPoint2: CGPoint(x: frame.minX + 9, y: frame.minY))
			ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.minX + 31, y: frame.minY),
							  controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.3 * frame.height))
			ovalPath.addCurve(to: CGPoint(x: frame.minX + 20, y: frame.maxY),
							  controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.7 * frame.height),
							  controlPoint2: CGPoint(x: frame.minX + 31, y: frame.maxY))
			ovalPath.addCurve(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height),
							  controlPoint1: CGPoint(x: frame.minX + 9, y: frame.maxY),
							  controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 0.78 * frame.height))
		}
		ovalPath.close()
		return ovalPath
	}
	public func iconMargins(for edge: UIRectEdge) -> (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
//		if edge == .left {
			return (top: 0.0, right: 0.0, bottom: 0.0, left: 0.0)
//		} else {}
	}
}

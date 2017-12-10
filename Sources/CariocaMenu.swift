//
//  CariocaMenu.swift
//  CariocaMenu
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import Foundation
import UIKit
///🇧🇷 Carioca Menu 🇧🇷
public class CariocaMenu: NSObject, CariocaGestureManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    ///The menu's content controller
    let controller: CariocaController
    ///The view in which the menu will be displayed
    let hostView: UIView
    ///The edges of the menu. Supported : .left, .right
    let edges: [UIRectEdge]
    ///The container view. Created programatically,
    ///it takes the same dimensions as the host view
    let container: CariocaMenuContainerView
    ///Gestures manager
    let gestureManager: CariocaGestureManager
    ///The selected index of the menu. Default: 0
	internal var selectedIndex: Int
	///The indicatorView
	let indicator: CariocaIndicatorView
    ///The delegate receiving menu's events
    weak var delegate: CariocaDelegate?

    ///Initialises 🇧🇷 Carioca Menu 🇧🇷
    ///- Parameter controller: The menu's dataSource
    ///- Parameter hostView: The view in which the menu will be displayed
    ///- Parameter edges: The supported edges
    ///- Parameter delegate: The menu's event delegate
	///- Parameter selectedIndex: The menu's default selected index
	///- Parameter indicator: The custom indicator view
    init(controller: CariocaController,
         hostView: UIView,
         edges: [UIRectEdge],
         delegate: CariocaDelegate,
		 selectedIndex: Int = 0,
		 indicator: CariocaIndicator) {
        self.controller = controller
        self.hostView = hostView
        self.edges = edges
        self.container = CariocaMenuContainerView(frame: hostView.frame,
                                                  dataSource: controller)
        self.gestureManager = CariocaGestureManager(hostView: hostView,
                                                    controller: controller,
                                                    edges: edges,
                                                    container: container,
													selectedIndex: selectedIndex)
        self.delegate = delegate
		self.selectedIndex = selectedIndex
		self.indicator = CariocaIndicatorView(edge: edges.first!, indicator: indicator)
		super.init()
        self.gestureManager.delegate = self
		self.controller.tableView.dataSource = self
		self.controller.tableView.delegate = self
        self.hideMenu()
    }

    ///Adds the menu's container view in the host view
    func addInHostView() {
        hostView.addSubview(container)
		if let blurStyle = controller.blurStyle {
			container.addBlurView(style: blurStyle)
		}
        hostView.addConstraints(container.makeAnchorConstraints(to: hostView))
		indicator.addIn(hostView, tableView: controller.tableView, position: controller.indicatorPosition)
		indicator.iconView.display(icon: controller.menuItems.first!.icon)
		indicator.show(edge: edges.first!, hostView: hostView, isTraversingView: false)
		let tapGesture = UITapGestureRecognizer(target: self, action: .tappedIndicatorView)
		tapGesture.numberOfTapsRequired = 1
		indicator.addGestureRecognizer(tapGesture)
	}

	///Called from the hostview, if a rotation has been detected.
	///Moves the indicator at 50% of the hostView.
	func hostViewDidRotate() {
		let yScreenMiddle = hostView.frame.height / 2.0
		gestureManager.panned(yLocation: yScreenMiddle,
							  edge: gestureManager.openingEdge,
							  state: .began,
							  fromGesture: false)
		gestureManager.panned(yLocation: yScreenMiddle,
							  edge: gestureManager.openingEdge,
							  state: .changed)
		indicator.repositionXAfterRotation(hostView)
	}

	///Tap gesture event received. Forwards parameters to GestureManager, to simulate a Pan gesture.
	///- Parameter gesture: UITapGestureRecognizer
	@objc func tappedIndicatorView(_ gesture: UITapGestureRecognizer) {
		let yLocation  = gesture.location(in: hostView).y
		gestureManager.panned(yLocation: yLocation, edge: gestureManager.openingEdge, state: .began)
		gestureManager.panned(yLocation: yLocation, edge: gestureManager.openingEdge, state: .changed)
	}

    // MARK: Events delegate/forwarding

    ///Menu will open. Forwards call to openFromEdge
    ///- Parameter edge: The opening edge of the menu
    func willOpenFromEdge(edge: UIRectEdge) {
		delegate?.cariocamenu(self, willOpenFromEdge: edge)
		controller.tableView.reloadData()
		indicator.show(edge: edge, hostView: hostView, isTraversingView: true)
	}
	///Hide the menu
    func showMenu() {
        container.isHidden = false
    }
	///Show the menu
    func hideMenu() {
        container.isHidden = true
    }
	///The selection index was updated, while user panning in the view
	///- Parameter index: The updated selection index
	///- Parameter selectionFeedback: Should we make a selection feedback?
	func didUpdateSelectionIndex(_ index: Int, selectionFeedback: Bool) {
		indicator.moveTo(index: index, heightForRow: controller.heightForRow())
		let item = controller.menuItems[index]
		indicator.iconView.display(icon: item.icon)
		if selectionFeedback {
			makeSelectionFeedback()
		}
    }
	///Haptick feedback, if supported. Min iOS 10.0.
	internal func makeSelectionFeedback() {
		if #available(iOS 10.0, *) {
			let selectionFeedback = UISelectionFeedbackGenerator()
			selectionFeedback.selectionChanged()
		}
	}
	///The user did select a menu item
	///- Parameter index: The selected index
    func didSelectItem(at index: Int) {
		indicator.restore(hostView: hostView)
		selectedIndex = index
        delegate?.cariocamenu(self, didSelect: controller.menuItems[index], at: index)
		makeSelectionFeedback()
    }

	// MARK: UITableView datasource/delegate
	///Number of menu items
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return controller.menuItems.count
	}
	///Cell for row. Forwarded to the controller, with the extra edge parameter.
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return controller.tableView(tableView, cellForRowAt: indexPath, withEdge: gestureManager.openingEdge)
	}
	///Number of sections. Cannot be updated for now, as the menu's tableView only supports 1 section
	public func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	///UITableView selection delegate, forwarded to CariocaDelegate
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		didUpdateSelectionIndex(indexPath.row, selectionFeedback: true)
		hideMenu()
		didSelectItem(at: indexPath.row)
	}
	///Takes the specified heightForRow passed in the initialiser
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return controller.heightForRow()
	}
	///Default footer view (to hide extra separators)
	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
	}
}

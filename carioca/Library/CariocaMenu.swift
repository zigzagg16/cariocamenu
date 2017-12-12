// CariocaMenu.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 - 2017 Arnaud Schloune
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

//These keys will be used to save values in NSUserDefaults.
let userDefaultsBoomerangVerticalKey = "com.cariocamenu.boomerang.vertical"
let userDefaultsBoomerangHorizontalKey = "com.cariocamenu.boomerang.horizontal"

///The CariocaMenu class
open class CariocaMenu: NSObject, UIGestureRecognizerDelegate {
    /**
        Initializes an instance of a `CariocaMenu` object.
        - parameters:
          - dataSource: `CariocaMenuDataSource` The controller presenting your menu
        - returns: An initialized `CariocaMenu` object
    */
    public init(dataSource: CariocaMenuDataSource,
                delegate: CariocaMenuDelegate,
                hostView: UIView) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.hostView = hostView
        self.containerView = UIView()
        self.menuHeight = dataSource.heightByMenuItem() * CGFloat(dataSource.numberOfMenuItems())
        self.boomerang = .none
        leftIndicatorView = CariocaMenuIndicatorView(indicatorEdge: .left, tapGesture: nil)
        rightIndicatorView = CariocaMenuIndicatorView(indicatorEdge: .right, tapGesture: nil)
        super.init()
        leftIndicatorView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(CariocaMenu.tappedOnIndicatorView(_:))))
        rightIndicatorView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(CariocaMenu.tappedOnIndicatorView(_:))))
        leftIndicatorView.addInView(hostView, edge: .left)
        rightIndicatorView.addInView(hostView, edge: .right)
        addInView()
    }
    ///The main view of the menu.
    ///Will contain the blur effect view, and the menu view.
    ///Will match the hostView's frame with AutoLayout constraints.
    private var containerView: UIView
    ///The view in which containerView will be added as a subview.
    var hostView: UIView
    private var menuView: UIView {
        return dataSource.menuView
    }
    private var menuTopEdgeConstraint: NSLayoutConstraint?
    private var menuOriginalY: CGFloat = 0.0
    private var panOriginalY: CGFloat = 0.0
    private var sidePanLeft = UIScreenEdgePanGestureRecognizer()
    private var sidePanRight = UIScreenEdgePanGestureRecognizer()
    private var panGestureRecognizer = UIPanGestureRecognizer()
    private var longPressForDragLeft: UILongPressGestureRecognizer?
    private var longPressForDragRight: UILongPressGestureRecognizer?
    ///The datasource of the menu
    var dataSource: CariocaMenuDataSource
    ///The delegate of events
    open weak var delegate: CariocaMenuDelegate?
    /// The type of boomerang for the menu. Default : None
    open var boomerang: CariocaMenuBoomerangType
    /// The selected index of the menu
    open var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var preSelectedIndexPath: IndexPath!
    ///The edge on which the menu will open
    open var openingEdge: CariocaMenuEdge = .left
    private let menuHeight: CGFloat
    var leftIndicatorView: CariocaMenuIndicatorView
    var rightIndicatorView: CariocaMenuIndicatorView
    var indicatorOffset: CGFloat = 0.0
    var gestureHelperViewLeft: UIView?
    var gestureHelperViewRight: UIView?
    /// Allows the user to reposition the menu vertically. Should be called AFTER addIn View()
    var isDraggableVertically = false {
        didSet {
            updateDraggableIndicators()
        }
    }

    /// If true, the menu will always stay on screen. If false, it will depend on the user's gestures.
    var isAlwaysOnScreen = true

// MARK: - Menu methods
    ///Adds the menu in the container view
    private func addInView() {
        containerView.isHidden = true
        addBlur()
        containerView.backgroundColor = UIColor.clear
        hostView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        hostView.addConstraints([
            CariocaMenu.getEqualConstraint(containerView, toItem: hostView, attribute: .trailing),
            CariocaMenu.getEqualConstraint(containerView, toItem: hostView, attribute: .leading),
            CariocaMenu.getEqualConstraint(containerView, toItem: hostView, attribute: .bottom),
            CariocaMenu.getEqualConstraint(containerView, toItem: hostView, attribute: .top)
        ])
        containerView.setNeedsLayout()
        //Add the menuview to the container
        containerView.addSubview(menuView)
        //Gesture recognizers
        sidePanLeft.addTarget(self, action: #selector(CariocaMenu.gestureTouched(_:)))
        hostView.addGestureRecognizer(sidePanLeft)
        sidePanLeft.edges = .left
        sidePanRight.addTarget(self, action: #selector(CariocaMenu.gestureTouched(_:)))
        hostView.addGestureRecognizer(sidePanRight)
        sidePanRight.edges = .right
        panGestureRecognizer.addTarget(self, action: #selector(CariocaMenu.gestureTouched(_:)))
        containerView.addGestureRecognizer(panGestureRecognizer)

        //Autolayout constraints for the menu
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addConstraint(NSLayoutConstraint(item: menuView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: menuHeight))
        let topEdgeConstraint = CariocaMenu.getEqualConstraint(menuView, toItem: containerView, attribute: .top)
        containerView.addConstraints([
            CariocaMenu.getEqualConstraint(menuView, toItem: containerView, attribute: .width),
            CariocaMenu.getEqualConstraint(menuView, toItem: containerView, attribute: .leading),
            topEdgeConstraint
        ])
        menuTopEdgeConstraint = topEdgeConstraint
        menuView.setNeedsLayout()
        moveToTop()
        updateDraggableIndicators()
    }

    /**
        Manages the menu dragging vertically
        - parameters:
            - gesture: The long press gesture
    */
    func longPressedForDrag(_ gesture: UIGestureRecognizer) {
        guard let indicator = gesture.view as? CariocaMenuIndicatorView else { return }
        let location = gesture.location(in: containerView)

        if gesture.state == .began {
            indicator.moveInScreenForDragging()
        }

        if gesture.state == .changed {
            indicator.updateY(location.y - (indicator.size.height / 2))
        }

        if gesture.state == .ended {
            indicator.show()
            indicatorOffset = location.y - (indicator.size.height / 2)
            adaptMenuYForIndicatorY(indicator, afterDragging: true)
        }
    }

    /**
        Manages the menu position depending on the gesture (UIScreenEdgePanGestureRecognizer and UIPanGestureRecognizer)
        - parameters:
            - gesture: The gesture (EdgePan or Pan)
    */
    func gestureTouched(_ gesture: UIGestureRecognizer) {
        let location = gesture.location(in: gesture.view)
        //remove the status bar
        let topMinimum: CGFloat = 20.0
        let frameHeight = gesture.view?.frame.height ?? 0.0
        let bottomMaximum = frameHeight - menuHeight
        if gesture.state == .began {
            if gesture != panGestureRecognizer {
                let newEdge: CariocaMenuEdge = (gesture == sidePanLeft) ? .left : .right
                if openingEdge != newEdge {
                    openingEdge = newEdge
                    indicator(for: (openingEdge == .right) ? .left : .right).hide()
                    dataSource.setCellIdentifierForEdge((openingEdge == .left) ? "cellRight" : "cellLeft")
                }
            }
            delegate?.cariocaMenuWillOpen(self)
            showMenu()
            showIndicatorOnTopOfMenu(openingEdge)

            panOriginalY = location.y

            //Y to add to match the preselected index
            menuOriginalY = panOriginalY
                    - ((dataSource.heightByMenuItem() * CGFloat(selectedIndexPath.row))
                    + (dataSource.heightByMenuItem()/2))

            if isAlwaysOnScreen {
                if menuOriginalY < topMinimum {
                    menuOriginalY = topMinimum
                } else if menuOriginalY > bottomMaximum {
                    menuOriginalY = bottomMaximum
                }
            }
            menuTopEdgeConstraint?.constant = menuOriginalY
            delegate?.cariocaMenuDidOpen(self)
        }
        if gesture.state == .changed {
//            CariocaMenu.Log("changed \(Double(location.y))")

            let difference = panOriginalY - location.y
            var newYconstant = menuOriginalY + difference

            if isAlwaysOnScreen {
                newYconstant = (newYconstant < topMinimum) ? topMinimum :
                    ((newYconstant > bottomMaximum) ? bottomMaximum : newYconstant)
            }

            menuTopEdgeConstraint?.constant = newYconstant

            var matchingIndex = Int(floor((location.y - newYconstant) / dataSource.heightByMenuItem()))
            //check if < 0 or > numberOfMenuItems
            matchingIndex = (matchingIndex < 0) ?
                0 : ((matchingIndex > (dataSource.numberOfMenuItems()-1)) ?
                    (dataSource.numberOfMenuItems()-1) : matchingIndex)

            let calculatedIndexPath = IndexPath(row: matchingIndex, section: 0)

            if preSelectedIndexPath !=  calculatedIndexPath {
                if preSelectedIndexPath != nil {
                    dataSource.unselectRowAtIndexPath(preSelectedIndexPath)
                }
                preSelectedIndexPath = calculatedIndexPath
                dataSource.preselectRowAtIndexPath(preSelectedIndexPath)
            }

            updateIndicatorsForIndexPath(preSelectedIndexPath)
        }
        if gesture.state == .ended {
            menuOriginalY = location.y
            //Unselect the previously selected cell, but first, update the selectedIndexPath
            let indexPathForDeselection = selectedIndexPath
            selectedIndexPath = preSelectedIndexPath
            dataSource.unselectRowAtIndexPath(indexPathForDeselection)
            didSelectRowAtIndexPath(selectedIndexPath, fromContentController: true)
        }

        if gesture.state == .failed { CariocaMenu.log("Failed : \(gesture)") }
        if gesture.state == .possible { CariocaMenu.log("Possible : \(gesture)") }
        if gesture.state == .cancelled { CariocaMenu.log("cancelled : \(gesture)") }
    }
    /**
        Calls the delegate actions for row selection
        - parameters:
            - indexPath: The selected index path
            - fromContentController: Bool value precising the source of selection
    */
    open func didSelectRowAtIndexPath(_ indexPath: IndexPath, fromContentController: Bool) {
        if preSelectedIndexPath != nil {
            dataSource.unselectRowAtIndexPath(preSelectedIndexPath)
            preSelectedIndexPath = nil
        }
        //Unselect the previously selected cell, but first, update the selectedIndexPath
        let indexPathForDeselection = selectedIndexPath
        selectedIndexPath = indexPath
        if !fromContentController {
            dataSource.selectRowAtIndexPath(indexPath)
        } else {
            dataSource.unselectRowAtIndexPath(indexPathForDeselection)
            dataSource.setSelectedIndexPath(indexPath)
        }
        delegate?.cariocaMenuDidSelect(self, indexPath: indexPath)
        updateIndicatorsForIndexPath(indexPath)
        if fromContentController {
            hideMenu()
        }
    }

    ///Gestures management
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    ///Makes sure the containerView is on top of the hostView
    open func moveToTop() {
        hostView.bringSubview(toFront: containerView)
        if let helperLeft = gestureHelperViewLeft {
            hostView.bringSubview(toFront: helperLeft)
        }
        if let helperRight = gestureHelperViewRight {
            hostView.bringSubview(toFront: helperRight)
        }
        hostView.bringSubview(toFront: leftIndicatorView)
        hostView.bringSubview(toFront: rightIndicatorView)
    }
    ///Adds blur to the container view (real blur for iOS > 7)
    private func addBlur() {
        if NSClassFromString("UIVisualEffectView") != nil {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: dataSource.blurStyle))
                as UIVisualEffectView
            visualEffectView.frame = containerView.bounds
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(visualEffectView)
        } else {
            let visualEffectView = UIView(frame: containerView.bounds)
            visualEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(visualEffectView)
        }
    }

// MARK: - Menu visibility

    ///Shows the menu
    open func showMenu() {
        gestureHelperViewLeft?.isHidden = true
        gestureHelperViewRight?.isHidden = true
        containerView.isHidden = false
        containerView.alpha = 1
        hostView.layoutIfNeeded()
    }

    ///Hides the menu
    open func hideMenu() {
        indicator(for: openingEdge).restoreOnOriginalEdge(boomerang, completion: {
            let edgeToCheckAfterFirstAnimation: CariocaMenuEdge =
                self.boomerang == .verticalAndHorizontal ? CariocaMenu.getBoomerangHorizontalValue() : self.openingEdge

            //show back only if it's on the same edge (always true if no horizontal boomerang)
            if edgeToCheckAfterFirstAnimation != self.openingEdge {
                let otherIndicator = self.indicator(for: self.openingEdge == .right ? .left : .right)
                let offsetSaved = CariocaMenu.getBoomerangVerticalValue()
                otherIndicator.updateY(offsetSaved)
                otherIndicator.show()
                self.openingEdge = edgeToCheckAfterFirstAnimation
            }
        })

        delegate?.cariocaMenuWillClose(self)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.containerView.alpha = 0
            }, completion: { _ -> Void in
                self.containerView.isHidden = true
                self.gestureHelperViewLeft?.isHidden = false
                self.gestureHelperViewRight?.isHidden = false
                self.delegate?.cariocaMenuDidClose(self)
                self.dataSource.setCellIdentifierForEdge((self.openingEdge == .left) ? "cellRight" : "cellLeft")
        })
    }

// MARK: - Indicators
    ///Manages the tap on an indicator view
    func tappedOnIndicatorView(_ tap: UIGestureRecognizer) {
        // swiftlint:disable force_cast
        let indicator = tap.view as! CariocaMenuIndicatorView
        // swiftlint:enable force_cast
        openingEdge = indicator.edge
        delegate?.cariocaMenuWillOpen(self)
        if menuOriginalY == 0 || boomerang == .vertical || boomerang == .verticalAndHorizontal {
            adaptMenuYForIndicatorY(indicator, afterDragging: false)
        }
        showMenu()
        showIndicatorOnTopOfMenu(openingEdge)
        delegate?.cariocaMenuDidOpen(self)
        dataSource.preselectRowAtIndexPath(selectedIndexPath)
    }
    /**
        Adapts the menu Y position depending on the position of the indicator
        (takes care to not move the menu off screen)
        - parameters:
            - indicator: The indicator to adapt
            - afterDragging: Bool indicating if the new vertical value must be saved for the boomerangs
    */
    private func adaptMenuYForIndicatorY(_ indicator: CariocaMenuIndicatorView, afterDragging: Bool) {
        //preset the menu Y
        let indicatorSpace = (dataSource.heightByMenuItem() - indicator.size.height) / 2
        let topConstraintConstant = indicator.topConstraint?.constant ?? 0.0
        var menuY = topConstraintConstant -
            (CGFloat(selectedIndexPath.row) * dataSource.heightByMenuItem()) -
            indicatorSpace

        if isAlwaysOnScreen {
            //remove the status bar
            let topMinimum: CGFloat = 20.0
            let bottomMaximum = containerView.frame.height - menuHeight
            //check to not hide the menu
            menuY = (menuY < topMinimum) ? topMinimum : ((menuY > bottomMaximum) ? bottomMaximum : menuY)
        }

        menuOriginalY = menuY
        menuTopEdgeConstraint?.constant = CGFloat(menuOriginalY)
        updateIndicatorsForIndexPath(selectedIndexPath)
        dataSource.setCellIdentifierForEdge((openingEdge == .left) ? "cellRight" : "cellLeft")

        if afterDragging {
            indicatorOffset = topConstraintConstant
            UserDefaults.standard.set(Double(indicatorOffset), forKey: userDefaultsBoomerangVerticalKey)
            UserDefaults.standard.synchronize()
        }
    }

    /**
        Shows the indicator on a precise position
        - parameters:
            - edge: Left or right edge
            - position: Top, Center or Bottom
            - offset: A random offset value. Should be negative when position is equal to `.Bottom`
    */
    open func showIndicator(_ edge: CariocaMenuEdge, position: CariocaMenuIndicatorViewPosition, offset: CGFloat) {
        indicatorOffset = indicator(for: edge).showAt(position, offset: offset)
        UserDefaults.standard.set(Double(indicatorOffset), forKey: userDefaultsBoomerangVerticalKey)
        UserDefaults.standard.setValue(edge.rawValue, forKey: userDefaultsBoomerangHorizontalKey)
        UserDefaults.standard.synchronize()
        openingEdge = edge
        updateIndicatorsImage(dataSource.iconForRowAtIndexPath(selectedIndexPath))
    }

    ///Shows the indicator on top of the selected menu indexPath
    private func showIndicatorOnTopOfMenu(_ edge: CariocaMenuEdge) {
        indicator(for: edge).moveYOverMenu(indicatorOffset,
                                                containerWidth: containerView.frame.size.width)
    }
    /**
        Returns the right indicator for the asked edge
        - parameters:
            - edge: Left or Right edge
        - returns: `CariocaMenuIndicatorView` The matching indicator
    */
    private func indicator(for edge: CariocaMenuEdge) -> CariocaMenuIndicatorView {
        return (edge == .right) ? rightIndicatorView : leftIndicatorView
    }
    /**
        Updates the image inside the indicator, to match the menu item
        - parameters:
            - image: The UIImage to display in the indicator
    */
    func updateIndicatorsImage(_ image: UIImage) {
        leftIndicatorView.updateImage(image)
        rightIndicatorView.updateImage(image)
    }
    /**
        Updates the indicator position to match the position of a specific indexPath in the menu
        - parameters:
            - indexPath: The concerned indexPath
    */
    private func updateIndicatorsForIndexPath(_ indexPath: IndexPath) {
        let indicator = self.indicator(for: openingEdge)
        let menuTop = menuTopEdgeConstraint?.constant ?? 0.0
        //menuTop + index position + center Y for indicator
        indicatorOffset = CGFloat(menuTop) +
                (CGFloat(indexPath.row) * dataSource.heightByMenuItem()) +
                ((dataSource.heightByMenuItem() - indicator.size.height) / 2)
        indicator.updateY(indicatorOffset)
        updateIndicatorsImage(dataSource.iconForRowAtIndexPath(indexPath))
    }

// MARK: - Edges
    /**
        Disables a specific edge for the menu (Both edges are active by default)
        - parameters:
            - edge: The edge to disable (Left or Right)
    */
    open func disableEdge(_ edge: CariocaMenuEdge) {
        hostView.removeGestureRecognizer((edge == .left) ? sidePanLeft : sidePanRight)
    }
// MARK: - Boomerangs
    ///Enables/disables the indicator drag gesture
    private func updateDraggableIndicators() {

        if isDraggableVertically {
            let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                                action: #selector(CariocaMenu.longPressedForDrag(_:)))
            longPressGesture.minimumPressDuration = 0.7
            leftIndicatorView.addGestureRecognizer(longPressGesture)
            rightIndicatorView.addGestureRecognizer(longPressGesture)
            longPressForDragRight = longPressGesture
            longPressForDragLeft = longPressGesture
        } else {
            if let longLeft = longPressForDragLeft {
                leftIndicatorView.removeGestureRecognizer(longLeft)
                longPressForDragLeft = nil
            }
            if let longRight = longPressForDragRight {
                rightIndicatorView.removeGestureRecognizer(longRight)
                longPressForDragRight = nil
            }
        }
    }
}

// CariocaMenu.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Arnaud Schloune
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
private let CariocaMenuUserDefaultsBoomerangVerticalKey = "com.cariocamenu.boomerang.vertical"
private let CariocaMenuUserDefaultsBoomerangHorizontalKey = "com.cariocamenu.boomerang.horizontal"

///The opening edge of the menu.
///- `LeftEdge`: Left edge of the screen
///- `RightEdge`: Right edge of the screen
@objc public enum CariocaMenuEdge : Int {
    case LeftEdge = 0
    case RightEdge = 1
}

///The initial vertical position of the menu
///- `Top`: Top of the hostView
///- `Center`: Center of the hostView
///- `Bottom`: Bottom of the hostView
@objc public enum CariocaMenuIndicatorViewPosition : Int {
    case Top = 0
    case Center = 1
    case Bottom = 2
}

///The boomerang type of the menu.
///- `None`: Default value. The indicators will always return where they were let.
///- `Vertical`: The indicators will always come back at the same Y value. They may switch from Edge if the user wants.
///- `VerticalAndHorizontal`: The indicators will always come back at the exact same place
@objc public enum CariocaMenuBoomerangType : Int {
    case None = 0
    case Vertical = 1
    case VerticalAndHorizontal = 2
}

//MARK: Delegate Protocol
@objc public protocol CariocaMenuDelegate {
    
    ///`Optional` Called when the menu is about to open
    ///- parameters:
    ///  - menu: The opening menu object
    optional func cariocaMenuWillOpen(menu:CariocaMenu)
    
    ///`Optional` Called when the menu just opened
    ///- parameters:
    ///  - menu: The opening menu object
    optional func cariocaMenuDidOpen(menu:CariocaMenu)
    
    ///`Optional` Called when the menu is about to be dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    optional func cariocaMenuWillClose(menu:CariocaMenu)
    
    ///`Optional` Called when the menu is dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    optional func cariocaMenuDidClose(menu:CariocaMenu)
    
    ///`Optional` Called when a menu item was selected
    ///- parameters:
    ///  - menu: The menu object
    ///  - indexPath: The selected indexPath
    optional func cariocaMenuDidSelect(menu:CariocaMenu, indexPath:NSIndexPath)
}

//MARK: - Datasource Protocol
@objc public protocol CariocaMenuDataSource {
    
    ///`Required` Gets the menu view, will be used to set constraints
    ///- returns: `UIVIew` the view of the menu that will be displayed
    func getMenuView()->UIView
    
    ///`Optional` Unselects a menu item
    ///- parameters:
    ///  - indexPath: The required indexPath
    ///- returns: Nothing. Void
    optional func unselectRowAtIndexPath(indexPath: NSIndexPath) -> Void
    
    ///`Optional` Will be called when the indicator hovers a menu item. You may apply some custom styles to your UITableViewCell
    ///- parameters:
    ///  - indexPath: The preselected indexPath
    optional func preselectRowAtIndexPath(indexPath:NSIndexPath)
    
    ///`Required` Will be called when the user selects a menu item (by tapping or just releasing the indicator)
    ///- parameters:
    ///  - indexPath: The selected indexPath
    func selectRowAtIndexPath(indexPath:NSIndexPath)
    
    ///`Required` Gets the height by each row of the menu. Used for internal calculations
    ///- returns: `CGFloat` The height for each menu item.
    ///- warning: The height should be the same for each row
    ///- todo: Manage different heights for each row
    func heightByMenuItem()->CGFloat
    
    ///`Required` Gets the number of menu items
    ///- returns: `Int` The total number of menu items
    func numberOfMenuItems()->Int
    
    ///`Required` Gets the icon for a specific menu item
    ///- parameters:
    ///  - indexPath: The required indexPath
    ///- returns: `UIImage` The image to show in the indicator. Should be the same that the image displayed in the menu.
    ///- todo: Add emoji support ?👍
    func iconForRowAtIndexPath(indexPath:NSIndexPath)->UIImage
    
    ///`Optional` Sets the selected indexPath
    ///- parameters:
    ///  - indexPath: The selected indexPath
    ///- returns: `Void` Nothing. Nada.
    optional func setSelectedIndexPath(indexPath:NSIndexPath)->Void
    
    ///`Optional` Sets the cell identifier. Used to adapt the tableView cells depending on which side the menu is presented.
    ///- parameters:
    ///  - identifier: The cell identifier
    ///- returns: `Void` Nada. Nothing.
    optional func setCellIdentifierForEdge(identifier:String)->Void
}

//MARK: -
public class CariocaMenu : NSObject, UIGestureRecognizerDelegate {
    
    /**
    Initializes an instance of a `CariocaMenu` object.
    - parameters:
      - dataSource: `CariocaMenuDataSource` The controller presenting your menu
    - returns: An initialized `CariocaMenu` object
    */
    public init(dataSource:CariocaMenuDataSource) {
        self.dataSource = dataSource
        self.menuView = dataSource.getMenuView()
        self.menuHeight = dataSource.heightByMenuItem() * CGFloat(dataSource.numberOfMenuItems())
        self.boomerang = .None
        super.init()
    }
    
    ///The main view of the menu. Will contain the blur effect view, and the menu view. Will match the hostView's frame with AutoLayout constraints.
    private var containerView = UIView()
    ///The view in which containerView will be added as a subview.
    private weak var hostView:UIView?
    private var menuView:UIView
    
    private var menuTopEdgeConstraint:NSLayoutConstraint?
    
    private var menuOriginalY:CGFloat = 0.0
    private var panOriginalY:CGFloat = 0.0
    
    private var sidePanLeft = UIScreenEdgePanGestureRecognizer()
    private var sidePanRight = UIScreenEdgePanGestureRecognizer()
    private var panGestureRecognizer = UIPanGestureRecognizer()
    private var longPressForDragLeft:UILongPressGestureRecognizer?
    private var longPressForDragRight:UILongPressGestureRecognizer?
    
    var dataSource:CariocaMenuDataSource
    weak var delegate:CariocaMenuDelegate?
    /// The type of boomerang for the menu. Default : None
    public var boomerang:CariocaMenuBoomerangType
    
    /// The selected index of the menu
    public var selectedIndexPath:NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    private var preSelectedIndexPath:NSIndexPath!
    
    public var openingEdge:CariocaMenuEdge = .LeftEdge
    private let menuHeight:CGFloat
    
    private var leftIndicatorView:CariocaMenuIndicatorView!
    private var rightIndicatorView:CariocaMenuIndicatorView!
    private var indicatorOffset:CGFloat = 0.0
    
    private var gestureHelperViewLeft:UIView!
    private var gestureHelperViewRight:UIView!
    
    /// Allows the user to reposition the menu vertically. Should be called AFTER addIn View()
    var isDraggableVertically = false  {
        didSet {
            updateDraggableIndicators()
        }
    }
    
    /// If true, the menu will always stay on screen. If false, it will depend on the user's gestures.
    var isAlwaysOnScreen = true
    
//MARK: - Menu methods
    
    /**
    Adds the menu in the selected view
    - parameters:
      - view: The view in which the menu will be shown, with indicators on top
    */
    public func addInView(view:UIView) {
        
        if(hostView == view){
            CariocaMenu.Log("Cannot be added to the same view twice")
            return
        }
        
        hostView = view
        containerView.hidden = true
        
        addBlur()
        containerView.backgroundColor = UIColor.clearColor()
        hostView?.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        
        hostView?.addConstraints([
            getEqualConstraint(containerView, toItem: hostView!, attribute: .Trailing),
            getEqualConstraint(containerView, toItem: hostView!, attribute: .Leading),
            getEqualConstraint(containerView, toItem: hostView!, attribute: .Bottom),
            getEqualConstraint(containerView, toItem: hostView!, attribute: .Top)
        ])
        
        containerView.setNeedsLayout()
        
        //Add the menuview to the container
        containerView.addSubview(menuView)
        
        //Gesture recognizers
        sidePanLeft.addTarget(self, action: Selector("gestureTouched:"))
        hostView!.addGestureRecognizer(sidePanLeft)
        sidePanLeft.edges = .Left
        
        sidePanRight.addTarget(self, action: Selector("gestureTouched:"))
        hostView!.addGestureRecognizer(sidePanRight)
        sidePanRight.edges = .Right
        
        panGestureRecognizer.addTarget(self, action: Selector("gestureTouched:"))
        containerView.addGestureRecognizer(panGestureRecognizer)

        //Autolayout constraints for the menu
        menuView.translatesAutoresizingMaskIntoConstraints = false;
        menuView.addConstraint(NSLayoutConstraint(item: menuView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: menuHeight))
        menuTopEdgeConstraint = getEqualConstraint(menuView, toItem: containerView, attribute: .Top)
        containerView.addConstraints([
            getEqualConstraint(menuView, toItem: containerView, attribute: .Width),
            getEqualConstraint(menuView, toItem: containerView, attribute: .Leading),
            menuTopEdgeConstraint!
        ])
        menuView.setNeedsLayout()
        
        addIndicator(.LeftEdge)
        addIndicator(.RightEdge)
        moveToTop()
        
        updateDraggableIndicators()
    }
    
    /**
    Manages the menu dragging vertically
    - parameters:
      - gesture: The long press gesture
    */
    func longPressedForDrag(gesture: UIGestureRecognizer) {
        let location = gesture.locationInView(containerView)
        let indicator = gesture.view as! CariocaMenuIndicatorView
        
        if(gesture.state == .Began) {
            indicator.moveInScreenForDragging()
        }
        
        if(gesture.state == .Changed) {
            indicator.updateY(location.y - (indicator.size.height / 2))
        }
        
        if(gesture.state == .Ended) {
            indicator.show()
            indicatorOffset = location.y - (indicator.size.height / 2)
            adaptMenuYForIndicatorY(indicator, afterDragging:true)
        }
    }
    
    /**
    Manages the menu position depending on the gesture (UIScreenEdgePanGestureRecognizer and UIPanGestureRecognizer)
    - parameters:
      - gesture: The gesture (EdgePan or Pan)
    */
    func gestureTouched(gesture: UIGestureRecognizer) {
    
        let location = gesture.locationInView(gesture.view)
        
        //remove the status bar
        let topMinimum:CGFloat = 20.0
        let bottomMaximum = (gesture.view?.frame.height)! - menuHeight
        
        if(gesture.state == .Began) {
            
            if(gesture != panGestureRecognizer){
                let newEdge:CariocaMenuEdge = (gesture == sidePanLeft) ? .LeftEdge : .RightEdge
                if openingEdge != newEdge {
                    openingEdge = newEdge
                    getIndicatorForEdge((openingEdge == .RightEdge) ? .LeftEdge : .RightEdge).hide()
                    dataSource.setCellIdentifierForEdge!((openingEdge == .LeftEdge) ? "cellRight" : "cellLeft")
                }
            }
            
            delegate?.cariocaMenuWillOpen!(self)
            showMenu()
            showIndicatorOnTopOfMenu(openingEdge)

            panOriginalY = location.y
            
            //Y to add to match the preselected index
            menuOriginalY = panOriginalY - ((dataSource.heightByMenuItem() * CGFloat(selectedIndexPath.row)) + (dataSource.heightByMenuItem()/2))
            
            if isAlwaysOnScreen {
                if menuOriginalY < topMinimum {
                    menuOriginalY = topMinimum
                }
                else if menuOriginalY > bottomMaximum {
                    menuOriginalY = bottomMaximum
                }
            }
            menuTopEdgeConstraint?.constant = menuOriginalY
            
            delegate?.cariocaMenuDidOpen!(self)
        }
        
        if(gesture.state == .Changed) {
//            CariocaMenu.Log("changed \(Double(location.y))")
            
            let difference = panOriginalY - location.y
            var newYconstant = menuOriginalY + difference
            
            if isAlwaysOnScreen {
                newYconstant = (newYconstant < topMinimum) ? topMinimum : ((newYconstant > bottomMaximum) ? bottomMaximum : newYconstant)
            }
            
            menuTopEdgeConstraint?.constant = newYconstant
            
            var matchingIndex = Int(floor((location.y - newYconstant) / dataSource.heightByMenuItem()))
            //check if < 0 or > numberOfMenuItems
            matchingIndex = (matchingIndex < 0) ? 0 : ((matchingIndex > (dataSource.numberOfMenuItems()-1)) ? (dataSource.numberOfMenuItems()-1) : matchingIndex)
            
            let calculatedIndexPath = NSIndexPath(forRow: matchingIndex, inSection: 0)
            
            if preSelectedIndexPath !=  calculatedIndexPath {
                if preSelectedIndexPath != nil {
                    dataSource.unselectRowAtIndexPath!(preSelectedIndexPath)
                }
                preSelectedIndexPath = calculatedIndexPath
                dataSource.preselectRowAtIndexPath?(preSelectedIndexPath)
            }
            
            updateIndicatorsForIndexPath(preSelectedIndexPath)
        }
        
        if(gesture.state == .Ended){
            menuOriginalY = location.y
            //Unselect the previously selected cell, but first, update the selectedIndexPath
            let indexPathForDeselection = selectedIndexPath
            selectedIndexPath = preSelectedIndexPath
            dataSource.unselectRowAtIndexPath!(indexPathForDeselection)
            didSelectRowAtIndexPath(selectedIndexPath, fromContentController:true)
        }
        
        if gesture.state == .Failed { CariocaMenu.Log("Failed : \(gesture)") }
        if gesture.state == .Possible { CariocaMenu.Log("Possible : \(gesture)") }
        if gesture.state == .Cancelled { CariocaMenu.Log("cancelled : \(gesture)") }
    }
    
    /**
    Calls the delegate actions for row selection
    - parameters:
      - indexPath: The selected index path
      - fromContentController: Bool value precising the source of selection
    */
    public func didSelectRowAtIndexPath(indexPath:NSIndexPath, fromContentController:Bool){
        if preSelectedIndexPath != nil {
            dataSource.unselectRowAtIndexPath!(preSelectedIndexPath)
            preSelectedIndexPath = nil
        }
        //Unselect the previously selected cell, but first, update the selectedIndexPath
        let indexPathForDeselection = selectedIndexPath
        selectedIndexPath = indexPath
        if(!fromContentController){
            dataSource.selectRowAtIndexPath(indexPath)
        }else{
            dataSource.unselectRowAtIndexPath!(indexPathForDeselection)
            dataSource.setSelectedIndexPath!(indexPath)
        }
        delegate?.cariocaMenuDidSelect!(self, indexPath: indexPath)
        updateIndicatorsForIndexPath(indexPath)
        if(fromContentController){
            hideMenu()
        }
    }
    
    ///Gestures management
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    ///Makes sure the containerView is on top of the hostView
    func moveToTop() {
        hostView?.bringSubviewToFront(containerView)
        if gestureHelperViewLeft != nil{
            hostView?.bringSubviewToFront(gestureHelperViewLeft)
        }
        if gestureHelperViewRight != nil{
            hostView?.bringSubviewToFront(gestureHelperViewRight)
        }
        hostView?.bringSubviewToFront(leftIndicatorView)
        hostView?.bringSubviewToFront(rightIndicatorView)
    }
    
    ///Adds blur to the container view (real blur for iOS > 7)
    private func addBlur() {
        if (NSClassFromString("UIVisualEffectView") != nil) {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)) as UIVisualEffectView
            visualEffectView.frame = containerView.bounds
            visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            containerView.addSubview(visualEffectView)
        }
        else {
            // TODO: add real blur for < iOS8
            let visualEffectView = UIView(frame: containerView.bounds)
            visualEffectView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            containerView.addSubview(visualEffectView)
        }
    }
    
//MARK: - Menu visibility

    ///Shows the menu
    public func showMenu() {
        gestureHelperViewLeft?.hidden = true
        gestureHelperViewRight?.hidden = true
        containerView.hidden = false
        containerView.alpha = 1
        hostView!.layoutIfNeeded()
    }
    
    ///Hides the menu
    public func hideMenu() {
        
        getIndicatorForEdge(openingEdge).restoreOnOriginalEdge(boomerang, completion:{
  
            let edgeToCheckAfterFirstAnimation:CariocaMenuEdge = self.boomerang == .VerticalAndHorizontal ? CariocaMenu.getBoomerangHorizontalValue() : self.openingEdge
            
            //show back only if it's on the same edge (always true if no horizontal boomerang)
            if edgeToCheckAfterFirstAnimation != self.openingEdge {
                let otherIndicator = self.getIndicatorForEdge(self.openingEdge == .RightEdge ? .LeftEdge : .RightEdge)
                let offsetSaved = CariocaMenu.getBoomerangVerticalValue()
                otherIndicator.updateY(offsetSaved)
                otherIndicator.show()
                self.openingEdge = edgeToCheckAfterFirstAnimation
            }
        })

        delegate?.cariocaMenuWillClose!(self)

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.containerView.alpha = 0
            }, completion: { (finished) -> Void in
                self.containerView.hidden = true
                self.gestureHelperViewLeft?.hidden = false
                self.gestureHelperViewRight?.hidden = false
                self.delegate?.cariocaMenuDidClose!(self)
        })
    }
    
//MARK: - Gesture helper views
    
    ///
    /**
    Adds Gesture helper views in the container view. Recommended when the whole view scrolls (`UIWebView`,`MKMapView`,...)
    - parameters:
      - edges: An array of `CariocaMenuEdge` on which to show the helpers
      - width: The width of the helper view. Maximum value should be `40`, but you're free to put what you want.
    */
    public func addGestureHelperViews(edges:Array<CariocaMenuEdge>, width:CGFloat) {
        
        if(edges.contains(.LeftEdge)){
            if(gestureHelperViewLeft != nil){
                gestureHelperViewLeft.removeFromSuperview()
            }
            gestureHelperViewLeft = prepareGestureHelperView(.Leading, width:width)
        }
        
        if(edges.contains(.RightEdge)){
            if(gestureHelperViewRight != nil){
                gestureHelperViewRight.removeFromSuperview()
            }
            gestureHelperViewRight = prepareGestureHelperView(.Trailing, width:width)
        }
        
        hostView?.bringSubviewToFront(leftIndicatorView)
        hostView?.bringSubviewToFront(rightIndicatorView)
    }
    
    /**
    Generates a gesture helper view with autolayout constraints
    - parameters:
      - edgeAttribute: `.Leading` or `.Trailing`
      - width: The width of the helper view.
    - returns: `UIView` The helper view constrained to the hostView edge
    */
    private func prepareGestureHelperView(edgeAttribute:NSLayoutAttribute, width:CGFloat)->UIView{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        hostView?.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        hostView?.addConstraints([
            getEqualConstraint(view, toItem: hostView!, attribute: edgeAttribute),
            NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width),
            getEqualConstraint(view, toItem: hostView!, attribute: .Bottom),
            getEqualConstraint(view, toItem: hostView!, attribute: .Top)
        ])
        
        view.setNeedsLayout()
        return view
    }

//MARK: - Indicators
    
    /**
    Adds an indicator on a specific edge of the screen
    - parameters:
      - edge: LeftEdge or RightEdge
    */
    private func addIndicator(edge:CariocaMenuEdge){
        
        //TODO: Check if the indicator already exists
        let indicator = CariocaMenuIndicatorView(indicatorEdge: edge, size:CGSizeMake(47, 40), shapeColor:UIColor(red:0.07, green:0.73, blue:0.86, alpha:1))
        indicator.addInView(hostView!, edge: edge)
        
        if(edge == .LeftEdge){
            leftIndicatorView = indicator
        }else{
            rightIndicatorView = indicator
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedOnIndicatorView:"))
        indicator.addGestureRecognizer(tapGesture)
    }
    
    ///Manages the tap on an indicator view
    func tappedOnIndicatorView(tap:UIGestureRecognizer){
        let indicator = tap.view as! CariocaMenuIndicatorView
        openingEdge = indicator.edge
        if(menuOriginalY == 0 || boomerang == .Vertical || boomerang == .VerticalAndHorizontal){
            adaptMenuYForIndicatorY(indicator, afterDragging:false)
        }
        showMenu()
        showIndicatorOnTopOfMenu(openingEdge)
        dataSource.preselectRowAtIndexPath?(selectedIndexPath)
    }
    
    /**
    Adapts the menu Y position depending on the position of the indicator (takes care to not move the menu off screen)
    - parameters:
      - indicator: The indicator to adapt
      - afterDragging: Bool indicating if the new vertical value must be saved for the boomerangs
    */
    private func adaptMenuYForIndicatorY(indicator:CariocaMenuIndicatorView, afterDragging:Bool){
        //preset the menu Y
        //the indicator Y - the selected index Y - the space to center the indicator ((dataSource.heightByMenuItem() - indicatorHeight)/2)
        let indicatorSpace = (dataSource.heightByMenuItem()-indicator.size.height)/2
        var menuY = (indicator.topConstraint?.constant)! - (CGFloat(selectedIndexPath.row) * dataSource.heightByMenuItem()) - indicatorSpace
        
        if isAlwaysOnScreen {
            //remove the status bar
            let topMinimum:CGFloat = 20.0
            let bottomMaximum = containerView.frame.height - menuHeight
            //check to not hide the menu
            menuY = (menuY < topMinimum) ? topMinimum : ((menuY > bottomMaximum) ? bottomMaximum : menuY)
        }
        
        menuOriginalY = menuY
        menuTopEdgeConstraint?.constant = CGFloat(menuOriginalY)
        updateIndicatorsForIndexPath(selectedIndexPath)
        dataSource.setCellIdentifierForEdge!((openingEdge == .LeftEdge) ? "cellRight" : "cellLeft")
        
        if afterDragging {
            indicatorOffset = (indicator.topConstraint?.constant)!
            NSUserDefaults.standardUserDefaults().setDouble(Double(indicatorOffset), forKey: CariocaMenuUserDefaultsBoomerangVerticalKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    /**
    Shows the indicator on a precise position
    - parameters:
      - edge: Left or right edge
      - position: Top, Center or Bottom
      - offset: A random offset value. Should be negative when position is equal to `.Bottom`
    */
    func showIndicator(edge:CariocaMenuEdge, position:CariocaMenuIndicatorViewPosition, offset:CGFloat){
        indicatorOffset = getIndicatorForEdge(edge).showAt(position, offset: offset)
        NSUserDefaults.standardUserDefaults().setDouble(Double(indicatorOffset), forKey: CariocaMenuUserDefaultsBoomerangVerticalKey)
        NSUserDefaults.standardUserDefaults().setValue(edge.rawValue, forKey: CariocaMenuUserDefaultsBoomerangHorizontalKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        openingEdge = edge
        updateIndicatorsImage(dataSource.iconForRowAtIndexPath(selectedIndexPath))
    }
    
    ///Shows the indicator on top of the selected menu indexPath
    private func showIndicatorOnTopOfMenu(edge:CariocaMenuEdge){
        getIndicatorForEdge(edge).moveYOverMenu(indicatorOffset, containerWidth:containerView.frame.size.width)
    }
    
    /**
    Returns the right indicator for the asked edge
    - parameters:
      - edge: Left or Right edge
    - returns: `CariocaMenuIndicatorView` The matching indicator
    */
    private func getIndicatorForEdge(edge:CariocaMenuEdge)->CariocaMenuIndicatorView {
        return (edge == .RightEdge) ? rightIndicatorView : leftIndicatorView
    }
    
    /**
    Updates the image inside the indicator, to match the menu item
    - parameters:
      - image: The UIImage to display in the indicator
    */
    func updateIndicatorsImage(image:UIImage){
        leftIndicatorView.updateImage(image)
        rightIndicatorView.updateImage(image)
    }
    
    /**
    Updates the indicator position to match the position of a specific indexPath in the menu
    - parameters:
      - indexPath: The concerned indexPath
    */
    private func updateIndicatorsForIndexPath(indexPath:NSIndexPath){
        let indicator = getIndicatorForEdge(openingEdge)
        //menuTop + index position + center Y for indicator
        indicatorOffset = CGFloat((menuTopEdgeConstraint?.constant)!) + (CGFloat(indexPath.row) * dataSource.heightByMenuItem()) + ((dataSource.heightByMenuItem() - indicator.size.height) / 2)
        indicator.updateY(indicatorOffset)
        updateIndicatorsImage(dataSource.iconForRowAtIndexPath(indexPath))
    }
    
//MARK: - Edges
    /**
    Disables a specific edge for the menu (Both edges are active by default)
    - parameters:
      - edge: The edge to disable (Left or Right)
    */
    public func disableEdge(edge:CariocaMenuEdge){
        if (hostView != nil){
            hostView?.removeGestureRecognizer((edge == .LeftEdge) ? sidePanLeft : sidePanRight)
        }
    }
    
//MARK: - Constraints
    /**
    Generates an Equal constraint
    - returns: `NSlayoutConstraint` an equal constraint for the specified parameters
    */
    private func getEqualConstraint(item: AnyObject, toItem: AnyObject, attribute: NSLayoutAttribute) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: 0)
    }
    
//MARK: - Boomerangs

    /**
    Gets the saved value for the vertical boomerang
    - returns: `CGFloat` The boomerang vertical value
    */
    class func getBoomerangVerticalValue()->CGFloat{
        let offset = NSUserDefaults.standardUserDefaults().doubleForKey(CariocaMenuUserDefaultsBoomerangVerticalKey)
        return(CGFloat(offset))
    }
    
    /**
    Gets the saved value for the horizontal boomerang
    - returns: `CariocaMenuEdge` the boomerang matching edge
    */
    class func getBoomerangHorizontalValue()->CariocaMenuEdge{
        let int = NSUserDefaults.standardUserDefaults().integerForKey(CariocaMenuUserDefaultsBoomerangHorizontalKey)
        return int == 1 ? .RightEdge : .LeftEdge
    }
    
    ///Resets the boomerang saved values
    class func resetBoomerangValues() {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: CariocaMenuUserDefaultsBoomerangVerticalKey)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: CariocaMenuUserDefaultsBoomerangHorizontalKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    ///Enables/disables the indicator drag gesture
    private func updateDraggableIndicators(){
        
        if isDraggableVertically {
            longPressForDragLeft = UILongPressGestureRecognizer(target: self, action: Selector("longPressedForDrag:"))
            longPressForDragLeft?.minimumPressDuration = 0.7
            leftIndicatorView.addGestureRecognizer(longPressForDragLeft!)
            longPressForDragRight = UILongPressGestureRecognizer(target: self, action: Selector("longPressedForDrag:"))
            longPressForDragRight?.minimumPressDuration = 0.7
            rightIndicatorView.addGestureRecognizer(longPressForDragRight!)
        } else {
            
            if longPressForDragLeft != nil {
                leftIndicatorView.removeGestureRecognizer(longPressForDragLeft!)
                longPressForDragLeft = nil
            }
            if longPressForDragRight != nil {
                rightIndicatorView.removeGestureRecognizer(longPressForDragRight!)
                longPressForDragRight = nil
            }
        }
    }
    
//MARK: - Logs
    ///Logs a string in the console
    ///- parameters:
    ///  - log: String to log
    class func Log(log:String) {print("CariocaMenu :: \(log)")}
}

//MARK: - IndicatorView Class
//MARK:

class CariocaMenuIndicatorView : UIView{
    
    /**
    Initializes an indicator for the menu
    - parameters:
      - indicatoreEdge: Left or Right edge
      - size: The size of the indicator
      - backgroundColor: The background color of the indicator
    - returns: `CariocaMenuIndicatorView` An indicator
    */
    init(indicatorEdge: CariocaMenuEdge, size:CGSize, shapeColor: UIColor) {
        edge = indicatorEdge
        imageView = UIImageView()
        self.size = size
        self.shapeColor = shapeColor
        super.init(frame: CGRectMake(0, 0, size.width, size.height))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clearColor()
    }

    //Don't know the utility of this code, but seems to be required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///The edge of the indicator. One indicator by edge maximum
    var edge:CariocaMenuEdge
    ///The size of the indicator. Will be used for calculations, needs to be public
    var size:CGSize
    ///The color of the shape
    private var shapeColor:UIColor
    ///The edge constraint, will depend on the edge. (Trailing or Leading)
    private var edgeConstraint:NSLayoutConstraint?
    ///The top constraint to adjust the vertical position
    var topConstraint:NSLayoutConstraint?
    ///The imageView to display your nicest icons.
    ///- warning: 👮Don't steal icons.👮
    private var imageView:UIImageView
    
    override func drawRect(frame: CGRect) {
        
        //This shape was drawed with PaintCode App
        let ovalPath = UIBezierPath()
        
        if(edge == .LeftEdge){
            ovalPath.moveToPoint(CGPointMake(frame.maxX, frame.minY + 0.50000 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.maxX - 20, frame.minY), controlPoint1: CGPointMake(frame.maxX, frame.minY + 0.22386 * frame.height), controlPoint2: CGPointMake(frame.maxX - 8.95, frame.minY))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 1, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.maxX - 31.05, frame.minY), controlPoint2: CGPointMake(frame.minX + 1, frame.minY + 0.30000 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.maxX - 20, frame.maxY), controlPoint1: CGPointMake(frame.minX + 1, frame.minY + 0.70000 * frame.height), controlPoint2: CGPointMake(frame.maxX - 31.05, frame.maxY))
            ovalPath.addCurveToPoint(CGPointMake(frame.maxX, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.maxX - 8.95, frame.maxY), controlPoint2: CGPointMake(frame.maxX, frame.minY + 0.77614 * frame.height))
            ovalPath.closePath()
            
        }else{
            //right
            ovalPath.moveToPoint(CGPointMake(frame.minX + 1, frame.minY + 0.50000 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 21, frame.minY), controlPoint1: CGPointMake(frame.minX + 1, frame.minY + 0.22386 * frame.height), controlPoint2: CGPointMake(frame.minX + 9.95, frame.minY))
            ovalPath.addCurveToPoint(CGPointMake(frame.maxX, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 32.05, frame.minY), controlPoint2: CGPointMake(frame.maxX, frame.minY + 0.30000 * frame.height))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 21, frame.maxY), controlPoint1: CGPointMake(frame.maxX, frame.minY + 0.70000 * frame.height), controlPoint2: CGPointMake(frame.minX + 32.05, frame.maxY))
            ovalPath.addCurveToPoint(CGPointMake(frame.minX + 1, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 9.95, frame.maxY), controlPoint2: CGPointMake(frame.minX + 1, frame.minY + 0.77614 * frame.height))
            ovalPath.closePath()
        }
        
        ovalPath.closePath()
        shapeColor.setFill()
        ovalPath.fill()
    }
    
    //MARK: - Indicator methods
    
    /**
    Adds the indicator in the hostView
    - parameters:
      - hostView: The view that will contain the indicator
      - edge: The edge on which to stick the indicator
    */
    func addInView(hostView:UIView, edge:CariocaMenuEdge) {
        
        hidden = true
        hostView.addSubview(self)
        
        var attrSideEdge:NSLayoutAttribute = (edge == .RightEdge) ? .Trailing : .Leading
        
        topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: hostView, attribute: .Top, multiplier: 1, constant: 0)
        
        //hide the indicator, will appear from the outside of the screen
        edgeConstraint = NSLayoutConstraint(item: self, attribute: attrSideEdge, relatedBy: .Equal, toItem: hostView, attribute: attrSideEdge, multiplier: 1, constant: getEdgeConstantValue(((size.width + 10) * -1)))
        
        hostView.addConstraints([
            edgeConstraint!,
            NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width),
            NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height),
            topConstraint!
            ])
        
        hostView.layoutIfNeeded()
        
        //add Icon imageView
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        //constraints for imageView
        attrSideEdge = (edge == .RightEdge) ? .Leading : .Trailing
        let valSideEdge:CGFloat = (edge == .RightEdge) ? 10.0 : -10.0
        
        self.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: attrSideEdge, relatedBy: .Equal, toItem: self, attribute: attrSideEdge, multiplier: 1, constant: valSideEdge),
            NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 24),
            NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 24),
            NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0),
            ])
        
        imageView.layoutIfNeeded()
    }

    /**
    Shows the indicator at the demanded position
    - parameters:
      - position: Top, Center or Bottom
      - offset: The offset to adjust the position. Should be negative `if position == .Bottom`
    - returns: `CGFloat` The top constraint constant value
    - todo: Save the final value in %, to avoid problems with multiple orientations
    */
    func showAt(position:CariocaMenuIndicatorViewPosition, offset:CGFloat) ->CGFloat{
        
        var yValue:CGFloat = 0
        
        if position == .Center {
            yValue = CGFloat((superview!.frame.size.height) / 2.0) - size.height/2
        }
        else if position == .Bottom {
            yValue = CGFloat((superview!.frame.size.height)) - size.height
        }
        else if position == .Top {
            yValue = 20
        }
    
        updateY(offset+yValue)
        superview!.layoutIfNeeded()
        superview!.bringSubviewToFront(self)
        show()
        
        return (topConstraint?.constant)!
    }
    
    /**
    Updates the Y position of the indicator
    - parameters:
      - y: The new value for the top constraint
    */
    func updateY(y:CGFloat){
        topConstraint?.constant = y
    }
    
    /**
    Restores the indicator on its initial position, depending on the boomerang type of the menu
    - parameters:
      - boomerang: The boomerang of the menu
      - completion: A completionBlock called when the animation is finished.
    */
    func restoreOnOriginalEdge(boomerang:CariocaMenuBoomerangType, completion: (() -> Void)){
        superview!.layoutIfNeeded()
        
        let isBoomerang = (boomerang != .None)
        //different positions if boomerang or not
        let position1 = isBoomerang ? getEdgeConstantValue(-80.0) : getEdgeConstantValue(-20.0)
        let position2 = isBoomerang ? position1 : getEdgeConstantValue(nil)
        
        let edgeToCheckAfterFirstAnimation:CariocaMenuEdge = boomerang == .VerticalAndHorizontal ? CariocaMenu.getBoomerangHorizontalValue() : edge
        
        animateX(position1, speed1:0.2, position2: position2, speed2:0.2, completion:{
            
            if isBoomerang{
                let offsetSaved = CariocaMenu.getBoomerangVerticalValue()
                if offsetSaved != 0.0{
                    self.updateY(offsetSaved)
                    self.superview!.layoutIfNeeded()
                    //show back only if it's on the same edge (always true if no horizontal boomerang)
                    if edgeToCheckAfterFirstAnimation == self.edge {
                        self.show()
                    }
                    completion()
                }
            }
        })
    }

    /**
    Adapts the Y position of the indicator, while being on top of the menu
    - parameters:
      - y: The new vertical position
      - containerWidth: The width of the hostView used to animate the indicator X position
    */
    func moveYOverMenu(y:CGFloat,containerWidth:CGFloat){
//        CariocaMenu.Log("moveYOverMenu \(y)")
        topConstraint?.constant = y
        superview!.layoutIfNeeded()
        superview!.bringSubviewToFront(self)
        hidden = false
        
        animateX(getEdgeConstantValue(containerWidth - self.size.width + 10), speed1 :0.2, position2: getEdgeConstantValue(containerWidth - (self.size.width + 1)), speed2 :0.2, completion:{
            
        })
    }
    
    ///Hides the indicator
    func hide(){
//        CariocaMenu.Log("hide \(self)")
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            }) { (finished) -> Void in
                self.hidden = true
        }
    }
    
    ///Shows the indicator
    func show(){
//        CariocaMenu.Log("show \(self)")
        hidden = false
        animateX(getEdgeConstantValue(0.0), speed1 :0.2, position2: getEdgeConstantValue(nil), speed2:0.4, completion:{
            
        })
    }
    
    ///Moves the indicator on the edge of the screen, when the user longPressed on it.
    func moveInScreenForDragging(){
//        CariocaMenu.Log("moveInScreenForDragging\(self)")
        animateX(getEdgeConstantValue(-5.0), speed1 :0.2, position2: getEdgeConstantValue(0.0), speed2:0.4, completion:{
            
        })
    }
    
    /**
    Updates the indicator's image
    - parameters:
      - image: An UIImage to display in the indicator
    */
    func updateImage(image:UIImage){
        imageView.image = image
    }
    
    //MARK: Internal methods
    
    /**
    Animates the X position of the indicator, in two separate animations
    - parameters:
      - position1: The X position of the first animation
      - spped1: The duration of the first animation
      - position2: The X position of the second animation
      - spped2: The duration of the second animation
      - completion: the completionBlock called when the two animations are finished
    */
    private func animateX(position1:CGFloat, speed1:Double, position2:CGFloat, speed2:Double, completion: (() -> Void)){
        
        edgeConstraint?.constant = position1
        UIView.animateWithDuration(speed1,delay:0, options: [.CurveEaseIn], animations: { () -> Void in
            self.superview!.layoutIfNeeded()
            
            }) { (finished) -> Void in
                
                self.edgeConstraint?.constant = position2
                UIView.animateWithDuration(speed2,delay:0, options: [.CurveEaseOut], animations: { () -> Void in
                    self.superview!.layoutIfNeeded()
                    
                    }) { (finished) -> Void in
                        completion()
                }
        }
    }
    
    /**
    Calculates the value to set to the edgeConstraint. (Negative or positive, depending on the edge)
    - parameters:
      - value: The value to transform
    - returns: `CGFloat` The value to set to the constant of the edgeConstraint
    */
    private func getEdgeConstantValue(value:CGFloat!)->CGFloat{
        let val = (value != nil) ? value : -5.0
        return (edge == .RightEdge) ? (val * -1) :  val
    }
}

//
// CariocaMenuIndicatorView.swift
//

import Foundation
import UIKit

///The indicators contained into the menu (one on the left, one on the right)
class CariocaMenuIndicatorView: UIView {

    internal func canPress() -> Bool {
        return true
    }
    /**
        Initializes an indicator for the menu
        - parameters:
            - indicatoreEdge: Left or Right edge
            - size: The size of the indicator
            - backgroundColor: The background color of the indicator
        - returns: `CariocaMenuIndicatorView` An indicator
    */
    init(indicatorEdge: CariocaMenuEdge,
         size: CGSize = CGSize(width: 47, height: 40),
         shapeColor: UIColor = UIColor(red: 0.07, green: 0.73, blue: 0.86, alpha: 1),
         tapGesture: UITapGestureRecognizer?) {
        edge = indicatorEdge
        imageView = UIImageView()
        self.size = size
        self.shapeColor = shapeColor
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        if let gesture = tapGesture {
            self.addGestureRecognizer(gesture)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///The edge of the indicator. One indicator by edge maximum
    var edge: CariocaMenuEdge
    ///The size of the indicator. Will be used for calculations, needs to be public
    var size: CGSize
    ///The color of the shape
    fileprivate var shapeColor: UIColor
    ///The edge constraint, will depend on the edge. (Trailing or Leading)
    fileprivate var edgeConstraint: NSLayoutConstraint?
    ///The top constraint to adjust the vertical position
    var topConstraint: NSLayoutConstraint?
    ///The imageView to display your nicest icons.
    ///- warning: 👮Don't steal icons.👮
    fileprivate var imageView: UIImageView
    ///Drawing of the indicator. The shape was drawed using PaintCode
    override func draw(_ frame: CGRect) {
        //This shape was drawed with PaintCode App
        let ovalPath = UIBezierPath()
        if edge == .left {
            ovalPath.move(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.minY),
                              controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.22386 * frame.height),
                              controlPoint2: CGPoint(x: frame.maxX - 9.0, y: frame.minY))
            ovalPath.addCurve(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height),
                              controlPoint1: CGPoint(x: frame.maxX - 31.0, y: frame.minY),
                              controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 0.3 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.maxY),
                              controlPoint1: CGPoint(x: frame.minX, y: frame.minY + 0.7 * frame.height),
                              controlPoint2: CGPoint(x: frame.maxX - 31.0, y: frame.maxY))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height),
                              controlPoint1: CGPoint(x: frame.maxX - 9.0, y: frame.maxY),
                              controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.77614 * frame.height))
        } else {
            //right
            ovalPath.move(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 20, y: frame.minY),
                              controlPoint1: CGPoint(x: frame.minX, y: frame.minY + 0.22386 * frame.height),
                              controlPoint2: CGPoint(x: frame.minX + 9.0, y: frame.minY))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.5 * frame.height),
                              controlPoint1: CGPoint(x: frame.minX + 31.0, y: frame.minY),
                              controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.3 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 20, y: frame.maxY),
                              controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.7 * frame.height),
                              controlPoint2: CGPoint(x: frame.minX + 31.0, y: frame.maxY))
            ovalPath.addCurve(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height),
                              controlPoint1: CGPoint(x: frame.minX + 9.0, y: frame.maxY),
                              controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 0.77614 * frame.height))
        }
        ovalPath.close()
        shapeColor.setFill()
        ovalPath.fill()
    }
    // MARK: - Indicator methods
    /**
        Adds the indicator in the hostView
        - parameters:
            - hostView: The view that will contain the indicator
            - edge: The edge on which to stick the indicator
    */
    func addInView(_ hostView: UIView, edge: CariocaMenuEdge) {
        isHidden = true
        hostView.addSubview(self)
        let attrSideEdge: NSLayoutAttribute = (edge == .right) ? .trailing : .leading
        let topConstraintValue = NSLayoutConstraint(item: self,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: hostView,
                                           attribute: .top,
                                           multiplier: 1,
                                           constant: 0)
        //hide the indicator, will appear from the outside of the screen
        let edgeConstraintValue = NSLayoutConstraint(item: self,
                                            attribute: attrSideEdge,
                                            relatedBy: .equal,
                                            toItem: hostView,
                                            attribute: attrSideEdge,
                                            multiplier: 1,
                                            constant: getEdgeConstantValue(((size.width + 10) * -1)))
        hostView.addConstraints([
            edgeConstraintValue,
            NSLayoutConstraint(item: self,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: size.width),
            NSLayoutConstraint(item: self,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: size.height),
            topConstraintValue
            ])
        edgeConstraint = edgeConstraintValue
        topConstraint = topConstraintValue
        hostView.layoutIfNeeded()
        //add Icon imageView
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        addImageViewContraints(imageEdge: edge)
    }

    private func addImageViewContraints(imageEdge: CariocaMenuEdge) {
        //constraints for imageView
        let attrSideEdge: NSLayoutAttribute = (imageEdge == .right) ? .leading : .trailing
        let valSideEdge: CGFloat = (imageEdge == .right) ? 10.0 : -10.0

        self.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: attrSideEdge,
                               relatedBy: .equal, toItem: self,
                               attribute: attrSideEdge,
                               multiplier: 1, constant: valSideEdge),
            NSLayoutConstraint(item: imageView, attribute: .width,
                               relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1, constant: 24),
            NSLayoutConstraint(item: imageView, attribute: .height,
                               relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1, constant: 24),
            NSLayoutConstraint(item: imageView, attribute: .centerY,
                               relatedBy: .equal, toItem: self,
                               attribute: .centerY,
                               multiplier: 1, constant: 0)
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
    func showAt(_ position: CariocaMenuIndicatorViewPosition, offset: CGFloat) -> CGFloat {
        guard let parentView = superview else {
            print("❌ CariocaMenuIndicatorView does not have a superview.")
            return 0.0
        }
        var yValue: CGFloat = 0
        if position == .center {
            yValue = CGFloat((parentView.frame.size.height) / 2.0) - size.height / 2
        } else if position == .bottom {
            yValue = CGFloat((parentView.frame.size.height)) - size.height
        } else if position == .top {
            yValue = 20
        }

        updateY(offset+yValue)
        parentView.layoutIfNeeded()
        parentView.bringSubview(toFront: self)
        show()
        return topConstraint?.constant ?? 0.0
    }

    /**
        Updates the Y position of the indicator
        - parameters:
            - y: The new value for the top constraint
    */
    func updateY(_ value: CGFloat) {
        topConstraint?.constant = value
    }

    /**
        Restores the indicator on its initial position, depending on the boomerang type of the menu
        - parameters:
            - boomerang: The boomerang of the menu
            - completion: A completionBlock called when the animation is finished.
    */
    func restoreOnOriginalEdge(_ boomerang: CariocaMenuBoomerangType, completion: @escaping (() -> Void)) {
        guard let parentView = superview else {
            print("❌ restoreOnOriginalEdge: CariocaMenuIndicatorView does not have a superview.")
            return
        }
        parentView.layoutIfNeeded()
        let isBoomerang = (boomerang != .none)
        //different positions if boomerang or not
        let position1 = isBoomerang ? getEdgeConstantValue(-80.0) : getEdgeConstantValue(-20.0)
        let position2 = isBoomerang ? position1 : getEdgeConstantValue()

        let edgeToCheckAfterFirstAnimation: CariocaMenuEdge =
            boomerang == .verticalAndHorizontal ? CariocaMenu.getBoomerangHorizontalValue() : edge

        animateX(position1,
                 speed1: 0.2,
                 position2: position2,
                 speed2: 0.2,
                 completion: {
            if isBoomerang {
                let offsetSaved = CariocaMenu.getBoomerangVerticalValue()
                if offsetSaved != 0.0 {
                    self.updateY(offsetSaved)
                    self.superview?.layoutIfNeeded()
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
    func moveYOverMenu(_ value: CGFloat, containerWidth: CGFloat) {
//        CariocaMenu.Log("moveYOverMenu \(y)")
        guard let parentView = superview else {
            print("❌ moveYOverMenu: CariocaMenuIndicatorView does not have a superview.")
            return
        }
        topConstraint?.constant = value
        parentView.layoutIfNeeded()
        parentView.bringSubview(toFront: self)
        isHidden = false
        animateX(getEdgeConstantValue(containerWidth - self.size.width + 10),
                 speed1: 0.2,
                 position2: getEdgeConstantValue(containerWidth - (self.size.width + 1)),
                 speed2: 0.2,
                 completion: { }
        )
    }

    ///Hides the indicator
    func hide() {
//        CariocaMenu.Log("hide \(self)")
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            }, completion: { _ -> Void in
                self.isHidden = true
        })
    }

    ///Shows the indicator
    func show() {
//        CariocaMenu.Log("show \(self)")
        isHidden = false
        animateX(getEdgeConstantValue(0.0),
                 speed1: 0.2,
                 position2: getEdgeConstantValue(),
                 speed2: 0.4,
                 completion: { })
    }

    ///Moves the indicator on the edge of the screen, when the user longPressed on it.
    func moveInScreenForDragging() {
//        CariocaMenu.Log("moveInScreenForDragging\(self)")
        animateX(getEdgeConstantValue(-5.0),
                 speed1: 0.2,
                 position2: getEdgeConstantValue(0.0),
                 speed2: 0.4,
                 completion: { })
    }
    /**
        Updates the indicator's image
        - parameters:
            - image: An UIImage to display in the indicator
    */
    func updateImage(_ image: UIImage) {
        imageView.image = image
    }

    // MARK: Internal methods
    /**
        Animates the X position of the indicator, in two separate animations
        - parameters:
            - position1: The X position of the first animation
            - spped1: The duration of the first animation
            - position2: The X position of the second animation
            - spped2: The duration of the second animation
            - completion: the completionBlock called when the two animations are finished
    */
    fileprivate func animateX(_ position1: CGFloat,
                              speed1: Double,
                              position2: CGFloat,
                              speed2: Double,
                              completion: @escaping (() -> Void)) {
        edgeConstraint?.constant = position1
        UIView.animate(withDuration: speed1,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: { () -> Void in
                self.superview?.layoutIfNeeded() },
                       completion: { _ in
                            self.edgeConstraint?.constant = position2
                            UIView.animate(withDuration: speed2,
                                           delay: 0,
                                           options: [.curveEaseOut],
                                           animations: { () -> Void in
                                                self.superview?.layoutIfNeeded()},
                                           completion: { _ in completion() })
        })
    }
    /**
        Calculates the value to set to the edgeConstraint. (Negative or positive, depending on the edge)
        - parameters:
            - value: The value to transform
        - returns: `CGFloat` The value to set to the constant of the edgeConstraint
    */
    fileprivate func getEdgeConstantValue(_ value: CGFloat = -5.0) -> CGFloat {
        return (edge == .right) ? (value * -1) :  value
    }
}

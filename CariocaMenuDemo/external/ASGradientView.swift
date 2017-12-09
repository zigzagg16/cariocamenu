//
//  ASGradientView.swift
//
//  Created by Arnaud Schloune
//  Copyright (c) 2016 Arnaud Schloune. All rights reserved.
//

import UIKit
import QuartzCore

public typealias ASGradientColors = (start: UIColor, end: UIColor)

class ASGradientView: UIView, CAAnimationDelegate {

    fileprivate var currentIndex = 0
    var animationDuration = 4.0

    var colors = [ASGradientColors]() {
        didSet {
            currentIndex = 0
            setupView()
        }
    }

    // MARK: Overrides
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    // MARK: Internal functions

    // Setup the view appearance
    func setupView() {
        gradientLayer.colors = [colors[currentIndex].start.cgColor, colors[currentIndex].end.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        print("init gradient view")
        self.setNeedsDisplay()
    }

    // Get the main layer as CAGradientLayer
	//swiftlint:disable force_cast
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
	//swiftlint:enable force_cast

    // MARK: Functions
    func animateGradient() {
        let fromColors = gradientLayer.colors
        let toColors = [colors[currentIndex].start.cgColor, colors[currentIndex].end.cgColor]

        gradientLayer.colors = toColors

        let animation = CABasicAnimation(keyPath: "colors")

        animation.fromValue             = fromColors
        animation.toValue               = toColors
        animation.duration              = animationDuration
        animation.isRemovedOnCompletion   = true
        animation.fillMode              = kCAFillModeForwards
        animation.timingFunction        = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.delegate              = self

        // Add the animation to our layer
        gradientLayer.add(animation, forKey: "animateGradient")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let newIndex = currentIndex + 1
        currentIndex = (newIndex == (colors.count)) ? 0 : newIndex
        animateGradient()
    }

    func pause() -> Int {
        return pauseLayer(gradientLayer)
    }

    func resume() {
        resumeLayer(gradientLayer)
    }

    func togglePauseOrResume() {
        if gradientLayer.speed == 1.0 {
            _ = self.pause()
        } else {
            resume()
        }
    }

    fileprivate func pauseLayer(_ layer: CAGradientLayer) -> Int {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        return currentIndex
    }

    fileprivate func resumeLayer(_ layer: CAGradientLayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), to: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}

//
//  AppDelegate.swift
//  carioca
//
//  Created by Arnaud Schloune
//  Copyright (c) 2015 Arnaud Schloune. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, COSTouchVisualizerWindowDelegate {

    var window: UIWindow?
//    lazy var window: UIWindow? = {
//        var customWindow = COSTouchVisualizerWindow(frame: UIScreen.main.bounds)
//        customWindow.touchVisualizerWindowDelegate = self
//        
//        customWindow.fillColor = UIColor(red:0.07, green:0.73, blue:0.86, alpha:1)
//        customWindow.strokeColor = UIColor.clearColor
//        customWindow.touchAlpha = 0.4
//        
//        customWindow.rippleFillColor = UIColor(red:0.98, green:0.68, blue:0.22, alpha:1)
//        customWindow.rippleStrokeColor = UIColor.clearColor
//        customWindow.rippleAlpha = 0.4
//        
//        return customWindow
//    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func touchVisualizerWindowShouldAlwaysShowFingertip(_ window: COSTouchVisualizerWindow!) -> Bool {
        return true
    }
}

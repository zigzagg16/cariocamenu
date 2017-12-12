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
//        var customWindow = COSTouchVisualizerWindow(frame: UIScreen.mainScreen().bounds)
//        customWindow.touchVisualizerWindowDelegate = self
//        
//        customWindow.fillColor = UIColor(red:0.07, green:0.73, blue:0.86, alpha:1)
//        customWindow.strokeColor = UIColor.clearColor()
//        customWindow.touchAlpha = 0.4
//        
//        customWindow.rippleFillColor = UIColor(red:0.98, green:0.68, blue:0.22, alpha:1)
//        customWindow.rippleStrokeColor = UIColor.clearColor()
//        customWindow.rippleAlpha = 0.4
//        
//        return customWindow
//    }()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func touchVisualizerWindowShouldAlwaysShowFingertip(window: COSTouchVisualizerWindow!) -> Bool {
        return true
    }
}

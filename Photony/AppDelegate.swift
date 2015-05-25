//
//  AppDelegate.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/05/13.
//  Copyright (c) 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

let AppId = "995133941"
let GooeleAnalyticsId = "UA-53899497-9"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            let viewController = ViewController()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
        
        Fabric.with([Crashlytics()])
        
        if let gai = GAI.sharedInstance() {
            gai.trackerWithTrackingId(GooeleAnalyticsId)
            gai.dispatchInterval = 60 * 5
            gai.trackUncaughtExceptions = false
            gai.logger.logLevel = .None
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
}


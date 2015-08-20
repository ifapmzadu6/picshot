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
        
        // not simulator
        #if !( (arch(i386) || arch(x86_64)) && os(iOS) )
            Fabric.with([Crashlytics()])
        #endif
        
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


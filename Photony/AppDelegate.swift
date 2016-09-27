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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        Fabric.with([Crashlytics()])
        
        return true
    }
    
}


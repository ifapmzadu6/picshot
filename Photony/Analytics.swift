//
//  Analytics.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/05/15.
//  Copyright (c) 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit
import Crashlytics

class Analytics: NSObject {
    
    class func sendEventWithClass(selfClass: AnyClass, action: String) {
        sendEvent(category: NSStringFromClass(selfClass), action: action);
    }
    
    class func sendEvent(category: String, action: String) {
        Answers.logCustomEvent(withName: category, customAttributes: ["action": action])
    }
    
}

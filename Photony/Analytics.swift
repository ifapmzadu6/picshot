//
//  Analytics.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/05/15.
//  Copyright (c) 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit

class Analytics: NSObject {
    
    class func sendEventWithClass(#selfClass: AnyClass, action: String) {
        sendEvent(category: NSStringFromClass(selfClass), action: action);
    }
    
    class func sendEvent(#category: String, action: String) {
        sendEvent(category: category, action: action, optionalLabel: nil, optionalValue: nil)
    }
    
    class func sendEvent(#category: String!, action: String!, optionalLabel: String?, optionalValue: NSNumber?) {
        let label = (optionalLabel != nil) ? optionalLabel : "default"
        let value = (optionalValue != nil) ? optionalValue : 0
        
        let tracker = GAI.sharedInstance().trackerWithTrackingId(GooeleAnalyticsId)
        let sendObject = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build() as [NSObject: AnyObject];
        tracker.send(sendObject)
    }
    
}

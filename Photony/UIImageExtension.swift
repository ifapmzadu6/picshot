//
//  UIImageExtension.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/05/13.
//  Copyright (c) 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit

extension UIImage {
    
    func squaredImage() -> UIImage? {
        let width = CGFloat(CGImageGetWidth(CGImage))
        let height = CGFloat(CGImageGetHeight(CGImage))
        let length = min(width, height)
        let x = (width - length) / 2
        let y = (height - length) / 2
        let cropRect = CGRectMake(x, y, length, length)
        let imageRef = CGImageCreateWithImageInRect(CGImage, cropRect)
        return UIImage(CGImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
}

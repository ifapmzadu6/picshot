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
        if let cgImage = cgImage {
            let width = CGFloat(cgImage.width)
            let height = CGFloat(cgImage.height)
            let length = min(width, height)
            let x = (width - length) / 2
            let y = (height - length) / 2
            let cropRect = CGRect(x: x, y: y, width: length, height: length)
            if let imageRef = cgImage.cropping(to: cropRect) {
                return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
            }
        }
        return nil
    }
    
}

//
//  ImagePickerController.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/10/21.
//  Copyright © 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit

class ImagePickerController: UIImagePickerController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return nil
    }
    
}

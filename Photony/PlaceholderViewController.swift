//
//  PlaceholderViewController.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/05/21.
//  Copyright (c) 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.text = "picshot"
        label.font = UIFont(name: "Avenir-Roman", size: 26)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.sizeToFit()
        label.center.x = view.center.x - 1
        label.frame.origin.y = 43
        view.addSubview(label)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

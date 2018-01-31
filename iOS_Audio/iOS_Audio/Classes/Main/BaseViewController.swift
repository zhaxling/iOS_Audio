//
//  BaseViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/31.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.config()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 设置
    func config() {
        self.hidesBottomBarWhenPushed = false
        self.view.backgroundColor = kBackGroundColor()
    }
    
}

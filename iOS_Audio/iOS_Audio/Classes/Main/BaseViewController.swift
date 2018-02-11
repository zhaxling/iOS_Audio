//
//  BaseViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/31.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var _navigationTitle:String = "iOS"
    var navigationTitle: String {
        get {
            return _navigationTitle
        }
        set {
            _navigationTitle = newValue
            self.navigationItem.title = navigationTitle
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.config()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 设置 是在viewDidLoad之后调用
    func config() {
        self.hidesBottomBarWhenPushed = false
        self.view.backgroundColor = kBackGroundColor()
    }
    
    
    /// 设置adjustedContentInset
    ///
    /// - Parameter scrollView: 控制器器中的滚动视图
    func setContentInsetAdjustmentFalse(scrollView:UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}

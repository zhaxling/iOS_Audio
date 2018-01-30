//
//  RootViewController.swift
//  iOS_Audio
//
//  Created by ZXL on 2018/1/20.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    // 前一个选中下标
    var lastSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI()
        
        // Recorder - ST
        self.addSubViewController(viewController: STVoiceViewController(), title: "录音", image: "tabbar_mainframe", seletedImage: "tabbar_mainframeHL")
        
        // AudioUnit
        self.addSubViewController(viewController: AUViewController(), title: "AU", image: "tabbar_contacts", seletedImage: "tabbar_contactsHL")
        
        // STLists
        self.addSubViewController(viewController: STListsViewController(), title: "列表", image: "tabbar_discover", seletedImage: "tabbar_discoverHL")
        
        // STLists
        self.addSubViewController(viewController: STListsViewController(), title: "列表", image: "tabbar_me", seletedImage: "tabbar_meHL")
        
        
    }
    
    // 添加子控制器
    func addSubViewController(viewController:UIViewController, title:String, image:String, seletedImage:String) {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.title = title
        navVC.tabBarItem.image = UIImage(named: image)
        navVC.tabBarItem.selectedImage = UIImage(named: seletedImage)
        self.addChildViewController(navVC)
    }
    
    // 设置分栏 颜色
    func configUI() {
        let normalAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.gray]
        let selectedAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.blue]
        UITabBarItem.appearance().setTitleTextAttributes(normalAttribute, for: UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttribute, for: UIControlState.selected)
    }
    
    // 点击选中按钮发送通知
    func sendDoubleClickNoti() {
        print(#function)
    }
}

extension RootViewController : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == self.lastSelectedIndex {
            self.sendDoubleClickNoti()
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.lastSelectedIndex = tabBarController.selectedIndex
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]) {
        print(#function)
    }
    
    // 旋转方向
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }
    func tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    /** 转场动画 */
    /**
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
    }
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
    }
     */
    
}



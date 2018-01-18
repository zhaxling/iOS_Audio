//
//  Const.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/18.
//  Copyright © 2018年 zxl. All rights reserved.
//

import Foundation
import UIKit

// 当前系统版本
let kVersion = (UIDevice.current.systemVersion as NSString).floatValue
// 屏幕宽度
let kScreenHeight = UIScreen.main.bounds.height
// 屏幕高度
let kScreenWidth = UIScreen.main.bounds.width
/// iPhone 5
let isIPhone5 = kScreenHeight == 568 ? true : false
/// iPhone 6
let isIPhone6 = kScreenHeight == 667 ? true : false
/// iPhone 6P
let isIPhone6P = kScreenHeight == 736 ? true : false

// MARK:- 颜色方法
func RGBAColor (_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

// MARK:- 随机颜色
func randomColor() -> UIColor {
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    return UIColor.init(red:red, green:green, blue:blue , alpha: 1)
}

// MARK:- 全局颜色
func kGlobalColor() -> UIColor {
    return RGBAColor(255, 255, 255, a: 1)
}

func WIDTH(_ size:Float) -> CGFloat
{
    return CGFloat(size / 375.0 * Float(UIScreen.main.bounds.size.width))
}
func HEIGHT(_ size:Float) -> CGFloat
{
    return CGFloat(size / 667.0 * Float(UIScreen.main.bounds.size.height))
}

func customLog<T>(_ message: T, fileName: String = #file, methodName: String =  #function, lineNumber: Int = #line)
{
    #if DEBUG
        let str : String = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: "swift", with: "")
        print("\(str)\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

//
//  CallManager.h
//  iOS_Audio
//
//  Created by Apple on 2018/2/10.
//  Copyright © 2018年 zxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallManager : NSObject


/**
 获取实例 不是单例
 */
+ (instancetype)manager;

/**
 电话打进来
 */
- (void)callComing;

/**
 获取SIM卡的信息
 */
- (void)getCarrierInfo;

@end

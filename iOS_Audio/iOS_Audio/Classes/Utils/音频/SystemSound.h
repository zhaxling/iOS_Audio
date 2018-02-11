//
//  SystemSound.h
//  iOS_Audio
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 zxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSound : NSObject


/**
 播放系统服务音频

 @param path 音频路径
 @param completionHander 播放完成回调
 */
- (void)playSystemSound:(NSString *)path completionHander:(void(^)(void))completionHander;

/**
 播放提示音

 @param isBegin 是否是开始音
 */
+ (void)playSystemTipAudioIsBegin:(BOOL)isBegin;

@end

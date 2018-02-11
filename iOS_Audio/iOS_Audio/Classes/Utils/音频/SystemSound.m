//
//  SystemSound.m
//  iOS_Audio
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 zxl. All rights reserved.
//

#import "SystemSound.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedAscending)

typedef void(^SystemSoundBlock)(void);

@interface SystemSound()

@property (nonatomic, strong) SystemSoundBlock completionHander;

@end

static SystemSound * selfClass = nil;

@implementation SystemSound

- (instancetype)init
{
    self = [super init];
    if (self) {
        selfClass = self;
    }
    return self;
}

- (void)playSystemSound:(NSString *)path completionHander:(void(^)(void))completionHander{
    // 获取音频文件路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sound_recorder_click.wav" withExtension:nil];
    
    // 加载音效文件并创建 SoundID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    
    //CFTypeRef type = CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
    //CFStringRef ver = CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(),kCFBundleVersionKey);
    //NSString *appVersion = (__bridge NSString *)ver;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
            AudioServicesDisposeSystemSoundID(soundID);
            if (completionHander) {
                completionHander();
            }
        });
    }else{
        // 设置播放完成回调 ios 9以前
        self.completionHander = completionHander;
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallBack, NULL);
        // 无振动
        AudioServicesPlaySystemSound(soundID);
    }
    
    // 播放音效
    // 带有震动
    // AudioServicesPlayAlertSound(_soundID);
}

// iOS9以前
void soundCompleteCallBack(SystemSoundID soundID, void * clientDate) {
    NSLog(@"播放完成");
    AudioServicesDisposeSystemSoundID(soundID);
    if (selfClass.completionHander) {
        selfClass.completionHander();
    }
}

+ (void)playSystemTipAudioIsBegin:(BOOL)isBegin
{
    SystemSoundID soundID = isBegin ? 1117 : 1118;
    AudioServicesPlaySystemSound(soundID);
}


@end

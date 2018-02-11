//
//  CallManager.m
//  iOS_Audio
//
//  Created by Apple on 2018/2/10.
//  Copyright © 2018年 zxl. All rights reserved.
//

#import "CallManager.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <CallKit/CallKit.h>

@interface CallManager()<CXCallObserverDelegate>

@property (nonatomic, strong) CTCallCenter * callCenter;
@property (nonatomic, strong) CXCallObserver * callObserver;
@property (nonatomic, strong) NSDate * beforeDate;


@end

@implementation CallManager

+ (instancetype)manager{
    return [[CallManager alloc]init];
}

- (void)dealloc{
    [self.callObserver setDelegate:nil queue:dispatch_get_main_queue()];
    self.callObserver = nil;
}

- (void)callComing{
    if (@available(iOS 10.0, *)) {
        self.callObserver = [[CXCallObserver alloc]init];
        dispatch_queue_t callQueue = dispatch_queue_create("com.app.callObserver", DISPATCH_QUEUE_CONCURRENT);
        [self.callObserver setDelegate:self queue:callQueue];
    } else {
        self.callCenter = [[CTCallCenter alloc]init];
        self.callCenter.callEventHandler = ^(CTCall * call) {
            
            NSLog(@"%@  %@",call.callState,call.callID);
            // CTCallStateIncoming  48267853-7719-4B89-853E-35B24D258BEA
            if ([call.callState isEqualToString:CTCallStateDisconnected]) {
                
            }
            else if ([call.callState isEqualToString:CTCallStateConnected]) {
                
            }
            else if ([call.callState isEqualToString:CTCallStateIncoming]) {
                // 第一次电话打进来
            }
            else if ([call.callState isEqualToString:CTCallStateDialing]) {
                
            }
            else{
                
            }
        };
    }
}

- (void)getCarrierInfo{
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier * carrier = info.subscriberCellularProvider;
    
    // 输出运营商信息 包括运营商名称 MCC MNC CountryCode 是否允许VOIP
    NSLog(@"%@",carrier);
    // 输出数据业务信息
    NSLog(@"%@",info.currentRadioAccessTechnology);
}

#pragma mark CXCallObserverDelegate
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call{
     NSLog(@"outgoing :%d  onHold :%d   hasConnected :%d   hasEnded :%d",call.outgoing,call.onHold,call.hasConnected,call.hasEnded);
    
    //接通
    if (call.outgoing && call.hasConnected && !call.hasEnded) {
        //记录当前时间
        _beforeDate = [NSDate date];
    }
    //挂断
    if (call.outgoing && call.hasConnected && call.hasEnded) {
        //计算通话时长
        NSDate* dat = [NSDate dateWithTimeInterval:0 sinceDate:_beforeDate];
        NSTimeInterval a=[dat timeIntervalSinceNow];
        NSString *timeString = [NSString stringWithFormat:@"%0.f",fabs(a)];//转为字符型
        NSLog(@"%@秒",timeString);
    }
}


@end

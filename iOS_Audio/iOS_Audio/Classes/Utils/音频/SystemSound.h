//
//  SystemSound.h
//  iOS_Audio
//
//  Created by Apple on 2018/1/23.
//  Copyright © 2018年 zxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSound : NSObject

- (void)playSystemSound:(NSString *)path completionHander:(void(^)(void))completionHander;

@end

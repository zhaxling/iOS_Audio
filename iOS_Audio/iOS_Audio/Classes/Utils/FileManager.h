//
//  FileManager.h
//  iOS_Audio
//
//  Created by Apple on 2018/2/10.
//  Copyright © 2018年 zxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject


/**
 获取内存

 @return 内存大小
 */
+ (long long)diskFreeSpace;

@end

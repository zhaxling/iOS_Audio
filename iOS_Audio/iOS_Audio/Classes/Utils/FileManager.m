//
//  FileManager.m
//  iOS_Audio
//
//  Created by Apple on 2018/2/10.
//  Copyright © 2018年 zxl. All rights reserved.
//

#import "FileManager.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation FileManager

long long freeSpace() {
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    
    return freespace;
}

+ (long long)diskFreeSpace
{
    return freeSpace();
}


@end

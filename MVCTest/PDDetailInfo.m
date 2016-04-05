//
//  PDDetailInfo.m
//  MVCTest
//
//  Created by 张雷 on 16/1/9.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import "PDDetailInfo.h"

@implementation PDDetailInfo

- (void) setSt:(NSInteger)st
{
    _st = st;
    self.isLiving = [self isLive:self.st end:self.et];
}

- (void) setEt:(NSInteger)et
{
    _et = et;
    
    self.isLiving = [self isLive:self.st end:self.et];
}

#pragma mark - 自定义方法
- (NSInteger)isLive:(NSInteger)start end:(NSInteger)end
{
    NSInteger now = [[Tools dateToTimedsamp:[NSDate date]] integerValue];
   
    if (now < start)
    {
        return -1;
    }
    else if (now>=start && now<=end)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

@end

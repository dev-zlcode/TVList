//
//  SelectFliterConfigure.m
//  MVCTest
//
//  Created by 乐业天空 on 15/7/2.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "SelectFliterConfigure.h"

@implementation SelectFliterConfigure

-(id)init
{
    self = [super init];
    if (self)
    {
        self.titleColor = [UIColor blueColor];
        self.titleColorDefault = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:14];
        self.lineColor = [UIColor blueColor];
        self.lineHeight = 1.5f;
        self.bgLineColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        self.bgLineHeight = 1.0/[[UIScreen mainScreen] scale];
    }
    return self;
}

@end
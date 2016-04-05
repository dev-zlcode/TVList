//
//  BaseNavigationController.m
//  MVCTest
//
//  Created by 乐业天空 on 15/6/29.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "BaseNavigationController.h"

#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    // 设置导航按钮字颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // 设置导航背景色
    [[UINavigationBar appearance] setBackgroundImage:[[Tools imageWithTheColor:Color] stretchableImageWithLeftCapWidth:160 topCapHeight:30] forBarMetrics:UIBarMetricsDefault];
    
    if (!IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        //设置为NO，如果有导航，导航下面是（0，0） 相当于坐标下移64个点
        self.navigationBar.translucent=NO;
    }
    if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        self.navigationBar.shadowImage = nil;
    }
}

@end

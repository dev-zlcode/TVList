//
//  NetWorkManager.m
//  MVCTest
//
//  Created by 张雷 on 15/6/30.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#import "NetWorkManager.h"

@implementation NetWorkManager

//判断网络是否连接
//需要在appdelegate中[[AFNetworkReachabilityManager sharedManager] startMonitoring];
+ (BOOL)isNetworkConnectionAvailable
{
    BOOL isExistenceNetwork = YES;

    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]<=0)
    {
        isExistenceNetwork = NO;
    }
    
    return isExistenceNetwork;
}

+ (BOOL) isWifi
{
    BOOL isExistenceNetwork = NO;
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusReachableViaWiFi)
    {
        isExistenceNetwork = YES;
    }
    
    return isExistenceNetwork;
}

@end

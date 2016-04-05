//
//  NetWorkManager.h
//  MVCTest
//
//  Created by 张雷 on 15/6/30.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorkManager : NSObject

//判断网络是否可以用
+ (BOOL)isNetworkConnectionAvailable;

// 判断是否是wifi
+ (BOOL) isWifi;

@end

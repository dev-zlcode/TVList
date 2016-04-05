//
//  Constant.h
//  MVCTest
//
//  Created by 乐业天空 on 15/6/30.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#ifndef MVCTest_Constant_h
#define MVCTest_Constant_h

#import "Tools.h"
#import "FileUtil.h"
#import "UIView+Util.h"
#import "LocalStorageUtil.h"
#import "NetWorkManager.h"
#import "FMDBManager.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

// 常用的宏
#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define APPDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define NotifyCenter [NSNotificationCenter defaultCenter]
#define UserDefaults  [NSUserDefaults standardUserDefaults]

// 提示框
#define ALERT(x) [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:x delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

// RGB
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// debug 输出打印 released模式不输出打印
//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define NSLog(format, ...) do {                                             \
fprintf(stderr, "\n");                                                      \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "\n");                                                      \
} while (0)
#else
#define NSLog(...)
#endif

// 判断真机模拟器
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

// 判断系统版本
#define SYSTEM_VERSION                              [[[UIDevice currentDevice] systemVersion] floatValue]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 主题颜色
#define Color RGBHEX(0x3f99cd)

#endif

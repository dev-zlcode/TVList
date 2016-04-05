//
//  BaseViewController.h
//  MVCTest
//
//  Created by 乐业天空 on 15/6/29.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

//网络不稳定通知
#define NetErrCallBackNotification @"NetErrCallBackNotification"

typedef NS_ENUM(NSUInteger, TipType) {
    TipTypeSuccess = 1,    // 成功
    TipTypeError,          // 失败
    TipTypeInfo,           // 信息
};

@interface BaseViewController : UIViewController

//设置导航左边按钮
- (void)setNavigationLeftBarWithTitle:(NSString *)title;
//返回
- (void)gotoBack;

//------------------------------信息提示视图---------------------------------------------
//显示指示器
- (void)showIndicatorWithTitle:(NSString *)title;
- (void)showIndicatorWithTitle:(NSString *)title view:(UIView *)view;
//隐藏指示器
- (void)hideIndicatorView;
//显示提示视图
- (void)showTipView:(TipType)type withTitle:(NSString *)title;
// 加载在根视图
+ (void)showTipView:(TipType)type title:(NSString *)title;
//隐藏提示视图
- (void)hideTipView;

@end

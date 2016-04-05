//
//  AppDelegate.h
//  MVCTest
//
//  Created by 张雷 on 15/6/29.
//  Copyright (c) 2015年 zhanlgei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//登录
-(void)gotoLogin;
//主界面
-(void)gotoMainViewController;

@end


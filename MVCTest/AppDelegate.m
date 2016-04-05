//
//  AppDelegate.m
//  MVCTest
//
//  Created by 乐业天空 on 15/6/29.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "VersionViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSHomeDirectory());
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 不是第一次登录，不进入引导页，直接进入app
    if ([[LocalStorageUtil getInfo:@"Logined"] intValue] == 1)
    {
        [self gotoMainViewController];
    }
    // 是第一次登录，先进入引导页，再进入app
    else
    {
        [self gotoMainViewController];
//        [self gotoVersion];
    }
    
    return YES;
}

//引导页
-(void)gotoVersion
{
    VersionViewController *vc = [[VersionViewController alloc] init];
    self.window.rootViewController = vc;
}

//登录
-(void)gotoLogin
{
    LoginViewController *login = [[LoginViewController alloc] init];
    self.window.rootViewController = login;
}

//主界面
-(void)gotoMainViewController
{
    BaseTabBarController *vc = [[BaseTabBarController alloc] init];
    vc.tabBar.selectedImageTintColor = Color;
//    vc.tabBar.backgroundImage = [Tools imageWithTheColor:Color];
    self.window.rootViewController = vc;
}

@end

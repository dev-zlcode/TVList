//
//  BaseTabBarController.m
//  MVCTest
//
//  Created by 乐业天空 on 15/6/29.
//  Copyright (c) 2015年 myjobsky. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"

#import "SearchViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadViewControllers];
    
    self.selectedIndex = 1;
}

- (void)loadViewControllers
{
    //第一个个
    SearchViewController *search = [[SearchViewController alloc] init];
    BaseNavigationController *searchNav = [[BaseNavigationController alloc] initWithRootViewController:search];
    UITabBarItem *searchItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"main_bottom_tab_search_gray.png"] selectedImage:[UIImage imageNamed:@"main_bottom_tab_search_red.png"]];
    search.tabBarItem = searchItem;
    
    //第二个
    HomeViewController *guangChang = [[HomeViewController alloc] init];
    BaseNavigationController *guangChangNav = [[BaseNavigationController alloc] initWithRootViewController:guangChang];
    UITabBarItem *guangChangItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"main_bottom_tab_home_gray.png"] selectedImage:[UIImage imageNamed:@"main_bottom_tab_home_red.png"]];
    guangChang.tabBarItem = guangChangItem;
    
    //第三个
    SettingViewController *home = [[SettingViewController alloc] init];
    BaseNavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:home];
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"main_bottom_tab_recipe_gray.png"] selectedImage:[UIImage imageNamed:@"main_bottom_tab_recipe_red.png"]];
    home.tabBarItem = homeItem;
    
    // 将视图控制器添加至数组中
    NSArray *viewControllers = @[searchNav, guangChangNav, homeNav];
    self.viewControllers = viewControllers;
}

@end

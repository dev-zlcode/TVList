//
//  BaseVirtualViewController.m
//  MVCTest
//
//  Created by 张雷 on 15/11/4.
//  Copyright (c) 2015年 zhanlgei. All rights reserved.
//

#import "BaseVirtualViewController.h"

@interface BaseVirtualViewController ()

@end

@implementation BaseVirtualViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    // 用于解决虚拟控制器的布局超出问题
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320, self.view.frame.size.height);
}

@end

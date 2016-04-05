//
//  UIWebView+Cutter.h
//  ScreenShotTest
//
//  Created by 张雷 on 14/10/26.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Cutter)

#pragma mark - UIWebView截屏（一屏无法显示完整）,获得截屏图像
- (UIImage *)webViewScreenShot;

@end

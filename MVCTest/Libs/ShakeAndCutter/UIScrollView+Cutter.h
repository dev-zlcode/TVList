//
//  UIScrollView+Cutter.h
//  ScreenShotTest
//
//  Created by 张雷 on 14/10/26.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Cutter)

#pragma mark - UIScrollView截屏（一屏无法显示完整）,获得截屏图像
- (UIImage *)scrollViewsScreenShot;

@end

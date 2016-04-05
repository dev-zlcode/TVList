//
//  UIScrollView+Cutter.m
//  ScreenShotTest
//
//  Created by 张雷 on 14/10/26.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import "UIScrollView+Cutter.h"

@implementation UIScrollView (Cutter)

#pragma mark - UIScrollView截屏（一屏无法显示完整）,获得截屏图像
- (UIImage *)scrollViewsScreenShot
{
    UIGraphicsBeginImageContext(self.contentSize);
    
    //保存
    CGPoint savedContentOffset = self.contentOffset;
    CGRect savedFrame = self.frame;
    
    self.contentOffset = CGPointZero;
    self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //还原数据
    self.contentOffset = savedContentOffset;
    self.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

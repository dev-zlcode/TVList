//
//  UIWebView+Cutter.m
//  ScreenShotTest
//
//  Created by 张雷 on 14/10/26.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import "UIWebView+Cutter.h"
@implementation UIWebView (Cutter)

#pragma mark - UIWebView截屏（一屏无法显示完整）,获得截屏图像
- (UIImage *)webViewScreenShot
{
    UIGraphicsBeginImageContext(self.scrollView.contentSize);
    
    //保存
    CGPoint savedContentOffset = self.scrollView.contentOffset;
    CGRect savedFrame = self.scrollView.frame;
    
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    [self.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //还原数据
    self.scrollView.contentOffset = savedContentOffset;
    self.scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end

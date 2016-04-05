//
//  UIViewController+ShakeAndCutter.m
//  ScreenShotTest
//
//  Created by 张雷 on 14/10/25.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import "UIViewController+ShakeAndCutter.h"

#import "ShowImageViewController.h"

@implementation UIViewController (ShakeAndCutter)

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 摇一摇动作处理
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"began");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancel");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"end");
    
    [self cutterViewToDocument];
}

#pragma mark - 截屏处理
- (void)cutterViewToDocument
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.bounds.size);
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //模态显示
    ShowImageViewController *vc = [[ShowImageViewController alloc] init];
    vc.image = screenShotImage;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

@end

//
//  UIAlertView+Blocks.h
//  Blocks
//
//  Created by 张雷 on 16/1/19.
//  Copyright © 2016年 zhanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks)<UIAlertViewDelegate>

+ (UIAlertView *)presentWithTitle: (NSString *)title
                      WithMessage: (NSString *)message
                     cancelButton: (NSString *)cancelString
                     otherButtons: (NSArray *)otherStrings
                         onCancel: (void (^)(UIAlertView *alert))cancelBlock
                  onClickedButton: (void (^)(UIAlertView *alert, NSUInteger index))clickBlock;

@end
